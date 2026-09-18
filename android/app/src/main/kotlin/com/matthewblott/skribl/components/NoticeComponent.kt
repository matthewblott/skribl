package com.matthewblott.skribl.components

import android.util.Log
import android.widget.Toast
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import dev.hotwire.navigation.destinations.HotwireDestination
import dev.hotwire.navigation.fragments.HotwireFragment
import kotlinx.serialization.Serializable

class NoticeComponent (
  value: String,
  private val bridgeDelegate: BridgeDelegate<HotwireDestination>
) : BridgeComponent<HotwireDestination>(value, bridgeDelegate) {
  private val fragment: HotwireFragment
    get() = bridgeDelegate.destination.fragment as HotwireFragment

  override fun onReceive(message: Message) {
    when (message.event) {
      "show" -> {
        val data = message.data<MessageData>() ?: return
        val context = bridgeDelegate.destination.fragment.requireContext()
        Toast.makeText(context, data.message, Toast.LENGTH_SHORT).show()
      }
      else -> Log.w("NoticeComponent", "Unknown event for message: $message")
    }
  }

  @Serializable
  data class MessageData(
    val message: String,
  )
}
