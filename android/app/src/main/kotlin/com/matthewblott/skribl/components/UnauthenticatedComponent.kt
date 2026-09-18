package com.matthewblott.skribl.components

import android.util.Log
import com.matthewblott.skribl.activities.AuthenticatedActivity
import com.matthewblott.skribl.configuration.Settings
import dev.hotwire.core.bridge.BridgeComponent
import dev.hotwire.core.bridge.BridgeDelegate
import dev.hotwire.core.bridge.Message
import dev.hotwire.navigation.destinations.HotwireDestination
import dev.hotwire.navigation.fragments.HotwireFragment
import kotlinx.serialization.Serializable

class UnauthenticatedComponent(
  value: String,
  private val bridgeDelegate: BridgeDelegate<HotwireDestination>
) : BridgeComponent<HotwireDestination>(value, bridgeDelegate) {
  private val fragment: HotwireFragment
    get() = bridgeDelegate.destination.fragment as HotwireFragment

  override fun onReceive(message: Message) {
    when (message.event) {
      "connect" -> {
        Settings.userId = 0 
        if (fragment.activity is AuthenticatedActivity) {
          val activity = fragment.activity as AuthenticatedActivity
          activity.launchUnauthenticatedActivity()
        }
      }
      else -> Log.w("UnauthenticatedComponent", "Unknown event for message: $message")
    }
  }

  @Serializable
  data class MessageData(
    val value: String,
  )
}
