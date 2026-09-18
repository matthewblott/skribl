package com.matthewblott.skribl.services

import android.webkit.CookieManager as WebkitCookieManager
import okhttp3.Cookie
import okhttp3.CookieJar
import okhttp3.HttpUrl

class WebViewCookieJar (
  private val webkitCookieManager: WebkitCookieManager = WebkitCookieManager.getInstance()
) : CookieJar {

  override fun saveFromResponse(url: HttpUrl, cookies: List<Cookie>) {
    cookies.forEach { cookie ->
      webkitCookieManager.setCookie(url.toString(), "${cookie.name}=${cookie.value}")
    }
    webkitCookieManager.flush()
  }

  override fun loadForRequest(url: HttpUrl): List<Cookie> {
    val cookieHeader = webkitCookieManager.getCookie(url.toString()) ?: return emptyList()
    return cookieHeader.split(";").mapNotNull { pair ->
      val trimmed = pair.trim()
      if (trimmed.isEmpty()) return@mapNotNull null
      val parts = trimmed.split("=", limit = 2)
      if (parts.size != 2) return@mapNotNull null
      Cookie.Builder()
        .name(parts[0].trim())
        .value(parts[1].trim())
        .domain(url.host)
        .build()
    }
  }
}