import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Upload key for release builds: android/key.properties locally (Flutter
// convention, git ignored) or FALCO_* environment variables in CI. Without
// either, release packaging fails on the missing storeFile; debug builds are
// unaffected.
val keyProperties = Properties().apply {
    val file = rootProject.file("key.properties")
    if (file.exists()) file.inputStream().use { load(it) }
}

fun signing(key: String, env: String): String? = keyProperties.getProperty(key) ?: System.getenv(env)

android {
    namespace = "de.kiefer_networks.falco"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // Same as Falco 2, so existing installs receive Falco 3 as an update.
        applicationId = "de.kiefer_networks.falco"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Both from `version:` in pubspec.yaml (name+code).
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            signing("storeFile", "FALCO_STORE_FILE")?.let { storeFile = file(it) }
            storePassword = signing("storePassword", "FALCO_STORE_PASSWORD")
            keyAlias = signing("keyAlias", "FALCO_KEY_ALIAS")
            keyPassword = signing("keyPassword", "FALCO_KEY_PASSWORD")
        }
    }

    buildTypes {
        debug {
            // Installs next to the released app.
            applicationIdSuffix = ".debug"
        }
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"))
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
