package com.matthewblott.skribl.components

import android.util.Log
import androidx.lifecycle.lifecycleScope
import com.matthewblott.skribl.configuration.Settings
import com.matthewblott.skribl.fragments.DownloadFilePresenter
import com.matthewblott.skribl.services.ZipDownloadService
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import dev.hotwire.navigation.destinations.HotwireDestination
import dev.hotwire.navigation.fragments.HotwireFragment
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.serialization.Serializable

class DownloadComponent (
  value: String,
  private val bridgeDelegate: BridgeDelegate<HotwireDestination>
) : BridgeComponent<HotwireDestination>(value, bridgeDelegate) {
  private val fragment: HotwireFragment
    get() = bridgeDelegate.destination.fragment as HotwireFragment

  override fun onReceive(message: Message) {
    when (message.event) {
      "connect" -> {
        handleDownloadEvent(message)
      }
      else -> Log.w("DownloadComponent", "Unknown event for message: $message")
    }
  }
  
  private fun handleDownloadEvent(message: Message) {
    val data = message.data<MessageData>() ?: return
    fragment.lifecycleScope.launch {
      downloadZip(data.token)
    }
  }
  
  private suspend fun downloadZip(csrfToken: String) {
    try {
      val downloadService = ZipDownloadService()
      val destination = withContext(Dispatchers.IO) {
        downloadService.downloadZip(
          context = fragment.requireContext(),
          csrfToken = csrfToken,
          filename = "skribl.zip",
          userId = Settings.userId.toString(),
          baseUrl = Settings.current.url,
        )
      }
      Log.d("DownloadComponent", "fragment is ${fragment::class.simpleName}, implements presenter: ${fragment is DownloadFilePresenter}")
      (fragment as? DownloadFilePresenter)?.presentSavePicker(destination)
    } catch (e: Exception) {
      println(e.message) 
      // see point 4 on reporting this back to JS
    }
  }
  @Serializable
  data class MessageData(
    val token: String,
  )
}