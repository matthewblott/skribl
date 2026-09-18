package com.matthewblott.skribl.configuration

object Settings {
  var userId = 0
  val current: Environment = Environment.Local

  enum class Environment(val url: String) {
    Remote("https://skribl.coderscoffeehouse.com"),
    Local("http://10.0.2.2:3000")
  }

}