package com.matthewblott.skribl.configuration
import com.matthewblott.skribl.BuildConfig

object Settings {
  var userId = 0
  val current: Environment =
    if (BuildConfig.DEBUG) Environment.Local else Environment.Remote
  enum class Environment(val url: String) {
    Remote("https://skribl.coderscoffeehouse.com"),
    Local("http://10.0.2.2:3000")
  }
}