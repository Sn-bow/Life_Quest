import java.util.Properties
import java.io.FileInputStream

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
val androidManifestPath = if (admobAndroidAppId.isBlank()) {
    "src/nonMonetization/AndroidManifest.xml"
} else {
    "src/monetization/AndroidManifest.xml"
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
