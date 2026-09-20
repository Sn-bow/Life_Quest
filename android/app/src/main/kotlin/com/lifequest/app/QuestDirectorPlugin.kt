package com.lifequest.app

import android.app.ActivityManager
import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import com.google.ai.edge.litertlm.Backend
import com.google.ai.edge.litertlm.Contents
import com.google.ai.edge.litertlm.Conversation
import com.google.ai.edge.litertlm.ConversationConfig
import com.google.ai.edge.litertlm.Engine
import com.google.ai.edge.litertlm.EngineConfig
import com.google.ai.edge.litertlm.SamplerConfig
import com.google.ai.edge.litertlm.ThinkingConfig
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.RandomAccessFile
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicBoolean

/** Inference never opens a network connection. Only the explicit model download does. */
class QuestDirectorPlugin(context: Context, messenger: BinaryMessenger) : AutoCloseable {
    private val directory = File(context.noBackupFilesDir, "quest-director").apply { mkdirs() }
    private val modelFile = File(directory, "gemma-4-e2b.litertlm")
    private val partial = File(directory, "gemma-4-e2b.part")
    private val verified = File(directory, "verified.sha256")
    private val executor = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private val busy = AtomicBoolean(false)
    private val cancelled = AtomicBoolean(false)
    private val conversationLock = Any()
    private var conversation: Conversation? = null
    @Volatile private var connection: HttpURLConnection? = null
    @Volatile private var downloading = false
    @Volatile private var downloaded = 0L
    @Volatile private var closed = false
    private val memory = ActivityManager.MemoryInfo().also {
        (context.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager).getMemoryInfo(it)
    }
    // Conservative eligibility, not a claim of measured performance. Actual device QA is required.
    private val supported = Build.SUPPORTED_ABIS.contains("arm64-v8a") &&
        memory.totalMem >= 5500L * 1024 * 1024
    private val channel = MethodChannel(messenger, "com.lifequest.app/quest_director")

    init { channel.setMethodCallHandler(::handle) }

    private fun isReady(): Boolean = modelFile.length() == MODEL_BYTES &&
        verified.isFile && runCatching { verified.readText() == MODEL_SHA }.getOrDefault(false)

    private fun status(): Map<String, Any> = mapOf(
        "state" to when {
            !supported -> "unavailable"
            downloading -> "downloading"
            isReady() -> "available"
            else -> "downloadable"
        },
        "downloaded" to if (downloading) downloaded else partial.length(),
        "total" to MODEL_BYTES,
        "reason" to if (supported) "" else "device_memory_or_abi",
    )

    private fun handle(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "status" -> result.success(status())
            "cancel" -> { cancel(); result.success(null) }
            "download" -> execute(result) { download(); null }
            "deleteModel" -> execute(result) {
                // User-selected model cache removal, never character data.
                check(!isReady() || modelFile.delete()) { "model_delete_failed" }
                if (modelFile.exists() && !modelFile.delete()) error("model_delete_failed")
                if (partial.exists() && !partial.delete()) error("model_delete_failed")
                if (verified.exists() && !verified.delete()) error("model_delete_failed")
                null
            }
            "generate" -> {
                val system = call.argument<String>("system")
                val prompt = call.argument<String>("prompt")
                if (system == null || prompt == null || system.length > 6000 || prompt.length > 5000) {
                    result.error("invalid_input", "Invalid generation input", null)
                } else execute(result) { generate(system, prompt) }
            }
            else -> result.notImplemented()
        }
    }

    private fun execute(result: MethodChannel.Result, operation: () -> Any?) {
        if (closed || !busy.compareAndSet(false, true)) {
            result.error("busy", "A model operation is already running", null)
            return
        }
        cancelled.set(false)
        executor.execute {
            try {
                val value = operation()
                main.post { if (!closed) result.success(value) }
            } catch (error: Exception) {
                val code = if (cancelled.get()) "cancelled" else when (error.message) {
                    "no_space", "invalid_model", "incompatible", "model_missing", "model_delete_failed" -> error.message!!
                    else -> "model_operation_failed"
                }
                // Do not log prompts, generated text, goal notes or raw remote errors.
                main.post { if (!closed) result.error(code, "Model operation did not complete", null) }
            } finally {
                downloading = false
                connection?.disconnect()
                connection = null
                busy.set(false)
            }
        }
    }

    private fun checkCancelled() { if (cancelled.get() || closed) error("cancelled") }

    private fun download() {
        check(supported) { "incompatible" }
        if (isReady()) return
        downloading = true
        if (partial.length() > MODEL_BYTES) partial.delete()
        downloaded = partial.length()
        check(directory.usableSpace > MODEL_BYTES - downloaded + 256L * 1024 * 1024) { "no_space" }
        if (downloaded < MODEL_BYTES) {
            val remote = openDownload(downloaded)
            connection = remote
            val code = remote.responseCode
            if (code == 206) {
                check(remote.getHeaderField("Content-Range")?.startsWith("bytes $downloaded-") == true)
            } else {
                check(code == 200) { "download_failed" }
                downloaded = 0
                check(directory.usableSpace + partial.length() > MODEL_BYTES + 256L * 1024 * 1024) { "no_space" }
            }
            RandomAccessFile(partial, "rw").use { output ->
                output.setLength(downloaded)
                output.seek(downloaded)
                remote.inputStream.use { input ->
                    val buffer = ByteArray(128 * 1024)
                    while (true) {
                        checkCancelled()
                        val count = input.read(buffer)
                        if (count < 0) break
                        check(downloaded + count <= MODEL_BYTES) { "invalid_model" }
                        output.write(buffer, 0, count)
                        downloaded += count
                    }
                }
                output.fd.sync()
            }
            remote.disconnect()
            connection = null
        }
        checkCancelled()
        val digest = MessageDigest.getInstance("SHA-256")
        partial.inputStream().buffered().use { input ->
            val buffer = ByteArray(128 * 1024)
            while (true) {
                checkCancelled()
                val count = input.read(buffer)
                if (count < 0) break
                digest.update(buffer, 0, count)
            }
        }
        val sha = digest.digest().joinToString("") { "%02x".format(it) }
        if (partial.length() != MODEL_BYTES || sha != MODEL_SHA) {
            partial.delete()
            error("invalid_model")
        }
        checkCancelled()
        verified.delete()
        if (modelFile.exists()) check(modelFile.delete())
        check(partial.renameTo(modelFile))
        verified.writeText(MODEL_SHA)
    }

    private fun openDownload(offset: Long): HttpURLConnection {
        var url = URL(MODEL_URL)
        repeat(6) {
            checkCancelled()
            check(url.protocol == "https")
            val request = url.openConnection() as HttpURLConnection
            connection = request
            request.instanceFollowRedirects = false
            request.connectTimeout = 20_000
            request.readTimeout = 30_000
            request.setRequestProperty("Accept-Encoding", "identity")
            if (offset > 0) request.setRequestProperty("Range", "bytes=$offset-")
            val code = request.responseCode
            if (code !in listOf(301, 302, 303, 307, 308)) return request
            val location = request.getHeaderField("Location") ?: error("download_failed")
            url = URL(url, location)
            request.disconnect()
        }
        error("download_failed")
    }

    private fun generate(system: String, prompt: String): String {
        check(supported) { "incompatible" }
        check(isReady()) { "model_missing" }
        checkCancelled()
        val config = EngineConfig(modelPath = modelFile.absolutePath,
            backend = Backend.CPU(threadCount = 4), maxNumTokens = 2048,
            cacheDir = directory.absolutePath)
        Engine(config).use { engine ->
            engine.initialize()
            checkCancelled()
            val conversationConfig = ConversationConfig(
                systemInstruction = Contents.of(system),
                samplerConfig = SamplerConfig(topK = 20, topP = 0.95, temperature = 0.2, seed = 42),
                thinkingConfig = ThinkingConfig(enableThinking = false, thinkingTokenBudget = 0),
                automaticToolCalling = false,
                maxOutputToken = 550,
            )
            engine.createConversation(conversationConfig).use { active ->
                synchronized(conversationLock) { conversation = active }
                try {
                    checkCancelled()
                    val answer = active.sendMessage(prompt).toString()
                    checkCancelled()
                    check(answer.length <= 8000)
                    return answer
                } finally { synchronized(conversationLock) { conversation = null } }
            }
        }
    }

    private fun cancel() {
        cancelled.set(true)
        connection?.disconnect()
        synchronized(conversationLock) { runCatching { conversation?.cancelProcess() } }
    }

    override fun close() {
        closed = true
        channel.setMethodCallHandler(null)
        cancel()
        executor.shutdown()
    }

    companion object {
        const val MODEL_BYTES = 2588147712L
        const val MODEL_SHA = "181938105e0eefd105961417e8da75903eacda102c4fce9ce90f50b97139a63c"
        const val MODEL_URL = "https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/resolve/b3ca0d2f076785a8f4b2219ddbd2bdb99954eae1/gemma-4-E2B-it.litertlm"
    }
}
