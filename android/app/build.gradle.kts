plugins {
  alias(libs.plugins.android.application)
  alias(libs.plugins.kotlin.serialization)
  alias(libs.plugins.compose.compiler)
}

android {
  namespace = "com.matthewblott.skribl"
  compileSdk {
    version = release(37)
  }

  defaultConfig {
    applicationId = "com.matthewblott.skribl"
    minSdk = 28
    targetSdk = 37
    versionCode = 1
    versionName = "1.0"
  }
  buildFeatures {
    compose = true
  }
  buildTypes {
    release {
      isMinifyEnabled = true
      isShrinkResources = true
      proguardFiles(
        getDefaultProguardFile("proguard-android-optimize.txt"),
        "proguard-rules.pro"
      )
      ndk {
        debugSymbolLevel = "FULL"
      }
      optimization {
        enable = false
      }
    }
  }
  compileOptions {
    sourceCompatibility = JavaVersion.VERSION_17
    targetCompatibility = JavaVersion.VERSION_17
  }
}

dependencies {
  implementation(libs.androidx.activity.ktx)
  implementation(libs.androidx.appcompat)
  implementation(libs.androidx.constraintlayout)
  implementation(libs.androidx.core.ktx)
  implementation(libs.material)
  implementation("dev.hotwire:core:1.3.1")
  implementation("dev.hotwire:navigation-fragments:1.3.1")
  implementation("com.github.joemasilotti:bridge-components:0.14.0")
  implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.8.1")
  implementation(platform("androidx.compose:compose-bom:2026.06.00"))
  implementation("com.squareup.okhttp3:okhttp:4.12.0")
  implementation("com.squareup.okhttp3:okhttp-urlconnection:4.12.0")
  implementation("com.squareup.okhttp3:okhttp:4.12.0")
  implementation("androidx.compose.material3:material3")
  implementation("androidx.compose.ui:ui")
  implementation("androidx.compose.ui:ui-tooling-preview")
  implementation("androidx.compose.runtime:runtime")
}

