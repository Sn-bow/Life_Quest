import java.util.Properties
import java.io.FileInputStream
import java.util.Base64

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // END: FlutterFire Configuration
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

val admobAndroidAppId = providers
    .gradleProperty("ADMOB_ANDROID_APP_ID")
    .orElse("")
    .get()
// Flutter passes dart-defines as comma-separated Base64 strings. Native
// permissions must follow the SAME switches as Dart; an AdMob ID must never
// silently enable billing or advertising initialization.
val lifeQuestDefines = providers.gradleProperty("dart-defines").orElse("").get()
    .split(',').filter { it.isNotEmpty() }.mapNotNull { value ->
        val decoded = runCatching { String(Base64.getDecoder().decode(value), Charsets.UTF_8) }.getOrNull()
        decoded?.split('=', limit = 2)?.takeIf { it.size == 2 }?.let { it[0] to it[1] }
    }.toMap()
val lifeQuestBilling = lifeQuestDefines["LIFEQUEST_MONETIZATION_ENABLED"] == "true"
val lifeQuestAds = lifeQuestDefines["LIFEQUEST_ADS_ENABLED"] == "true"
val lifeQuestCloud = lifeQuestDefines["LIFEQUEST_CLOUD_ENABLED"] == "true"
if ((lifeQuestBilling || lifeQuestAds) && !lifeQuestCloud) {
    throw GradleException("Billing and ads require LIFEQUEST_CLOUD_ENABLED=true and a verified backend.")
}
if (lifeQuestAds && !Regex("ca-app-pub-[0-9]{16}~[0-9]{10}").matches(admobAndroidAppId)) {
    throw GradleException("Ads require a valid ADMOB_ANDROID_APP_ID Gradle property.")
}
val androidManifestPath = when {
    lifeQuestBilling && lifeQuestAds -> "src/monetization/AndroidManifest.xml"
    lifeQuestBilling -> "src/billingOnly/AndroidManifest.xml"
    lifeQuestAds -> "src/adsOnly/AndroidManifest.xml"
    else -> "src/nonMonetization/AndroidManifest.xml"
}

android {
    namespace = "com.lifequest.app"
    compileSdk = 36
    ndkVersion = "29.0.14206865"

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }


    defaultConfig {
        applicationId = "com.lifequest.app"
        minSdk = 26
        targetSdk = 36
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        manifestPlaceholders["admobAppId"] = admobAndroidAppId
    }

    sourceSets {
        getByName("debug") {
            manifest.srcFile(androidManifestPath)
        }
        getByName("profile") {
            manifest.srcFile(androidManifestPath)
        }
        getByName("release") {
            manifest.srcFile(androidManifestPath)
        }
    }

    signingConfigs {
        if (keystorePropertiesFile.exists()) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String
                keyPassword = keystoreProperties["keyPassword"] as String
                storeFile = file(keystoreProperties["storeFile"] as String)
                storePassword = keystoreProperties["storePassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (keystorePropertiesFile.exists()) {
                signingConfigs.getByName("release")
            } else {
                if (gradle.startParameter.taskNames.any { it.contains("Release", ignoreCase = true) }) {
                    throw GradleException("Missing android/key.properties for release signing")
                }
                null
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_11)
    }
}

flutter {
    source = "../.."
}

// --- 추가된 부분: 디슈가링 라이브러리 의존성 추가 ---
dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("com.google.ai.edge.litertlm:litertlm-android:0.17.0")
}
// --- 여기까지 ---
