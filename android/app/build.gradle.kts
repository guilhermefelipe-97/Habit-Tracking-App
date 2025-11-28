plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("org.jetbrains.kotlin.android")
    // O plugin do Flutter vem depois dos plugins Android e Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.habit_tracking"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17   // <- 17
        targetCompatibility = JavaVersion.VERSION_17   // <- 17
    }

    kotlinOptions {
        jvmTarget = "17"   // <- bate com o Java
    }

    defaultConfig {
        applicationId = "com.example.habit_tracking"
        minSdk = 23
        targetSdk = 35
        versionCode = 1
        versionName = "1.0"   // <- string, entre aspas
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}