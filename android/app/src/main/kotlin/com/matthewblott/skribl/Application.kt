package com.matthewblott.skribl

import com.masilotti.bridgecomponents.toast.ToastComponent
import com.matthewblott.skribl.components.AuthenticatedComponent
import com.matthewblott.skribl.components.ButtonComponent
import com.matthewblott.skribl.components.DownloadComponent
import com.matthewblott.skribl.components.NoticeComponent
import com.matthewblott.skribl.components.UnauthenticatedComponent
import com.matthewblott.skribl.fragments.DownloadFileFragment
import com.matthewblott.skribl.fragments.WebFragment
import dev.hotwire.core.bridge.BridgeComponentFactory
import dev.hotwire.core.bridge.KotlinXJsonConverter
import dev.hotwire.core.config.Hotwire
import dev.hotwire.core.turbo.config.PathConfiguration
import dev.hotwire.navigation.config.defaultFragmentDestination
import dev.hotwire.navigation.config.registerBridgeComponents
import dev.hotwire.navigation.config.registerFragmentDestinations

class Application : android.app.Application() {
  override fun onCreate() {
    super.onCreate()
    configureApp()
  }

  private fun configureApp() {
    Hotwire.config.jsonConverter = KotlinXJsonConverter()
    Hotwire.loadPathConfiguration(
      context = this,
      location = PathConfiguration.Location(
        assetFilePath = "json/path-configuration.json",
      ),
    )

    Hotwire.defaultFragmentDestination = WebFragment::class

    Hotwire.registerFragmentDestinations(
      WebFragment::class,
      DownloadFileFragment::class,
    )
    
    Hotwire.registerBridgeComponents(
        BridgeComponentFactory("authenticated", ::AuthenticatedComponent),
      BridgeComponentFactory("button", ::ButtonComponent),
      BridgeComponentFactory("download", ::DownloadComponent),
      BridgeComponentFactory("notice", ::NoticeComponent),
      BridgeComponentFactory("toast", ::ToastComponent),
      BridgeComponentFactory("unauthenticated", ::UnauthenticatedComponent),
    )
  }
}