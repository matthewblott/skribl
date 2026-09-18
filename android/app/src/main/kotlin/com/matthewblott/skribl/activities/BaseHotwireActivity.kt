package com.matthewblott.skribl.activities

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.webkit.WebView
import androidx.activity.enableEdgeToEdge
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.ContextCompat
import dev.hotwire.core.BuildConfig
import dev.hotwire.navigation.activities.HotwireActivity

abstract class BaseHotwireActivity : HotwireActivity() {

  private val requestLocalNetwork = registerForActivityResult(
    ActivityResultContracts.RequestPermission()
  ) { /* proceed regardless; Hotwire will just fail to load if denied */ }

  override fun onCreate(savedInstanceState: Bundle?) {
    enableEdgeToEdge()
    super.onCreate(savedInstanceState)
    ensureLocalNetworkPermission()
    if (BuildConfig.DEBUG) {
      WebView.setWebContentsDebuggingEnabled(true)
    }
  }

  private fun ensureLocalNetworkPermission() {
    if (ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_LOCAL_NETWORK)
      != PackageManager.PERMISSION_GRANTED) {
      requestLocalNetwork.launch(Manifest.permission.ACCESS_LOCAL_NETWORK)
    }
  }
}