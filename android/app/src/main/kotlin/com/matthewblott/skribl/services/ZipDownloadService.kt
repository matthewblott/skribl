package com.matthewblott.skribl.services

import android.content.Context
import android.util.Log
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlinx.coroutines.withContext
import okhttp3.Call
import okhttp3.Callback
import okhttp3.CookieJar
import okhttp3.FormBody
import okhttp3.JavaNetCookieJar
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import java.io.File
import java.io.IOException
import java.net.CookieManager
import java.net.CookiePolicy
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
//import kotlin.coroutines.suspendCancellableCoroutine

class ZipDownloadService(
  cookieJar: CookieJar = JavaNetCookieJar(
    CookieManager().apply { setCookiePolicy(CookiePolicy.ACCEPT_ALL) }
  )
) {
  sealed class DownloadError(message: String? = null, cause: Throwable? = null) :
    Exception(message, cause) {
    object InvalidResponse : DownloadError("Invalid response")
    data class ServerError(val statusCode: Int) : DownloadError("Server error: $statusCode")
    data class FileSystemError(val original: Throwable) : DownloadError(cause = original)
  }

  private val client: OkHttpClient = OkHttpClient.Builder()
//    .cookieJar(cookieJar)
    .cookieJar(WebViewCookieJar())
    .build()

  suspend fun downloadZip(
    context: Context,
    csrfToken: String,
    filename: String,
    userId: String,
    baseUrl: String
  ): File {
    
    val requestBody = "authenticity_token=$csrfToken"
      .toRequestBody("application/x-www-form-urlencoded".toMediaType())
    val request = Request.Builder()
      .url("$baseUrl/$userId/account/download")
      .post(requestBody)
      .addHeader("X-CSRF-Token", csrfToken)
      .build()
    val response = executeRequest(request)

//    val client = OkHttpClient.Builder()
//      .cookieJar(WebViewCookieJar())
//      .build()

//    val requestBody = FormBody.Builder()
//      .add("authenticity_token", csrfToken)
//      .build()
//    val request = Request.Builder()
//      .url("$baseUrl/$userId/account/download")
//      .url("$baseUrl/test-download")
//      .post(requestBody)
//      .addHeader("X-CSRF-Token", csrfToken)
//      .build()
//    val response = executeRequest(request) // uses `client` internally 
    
    response.use { resp ->
      if (!resp.isSuccessful) {
        throw DownloadError.ServerError(resp.code)
      }

      val body = resp.body ?: throw DownloadError.InvalidResponse

      return withContext(Dispatchers.IO) {
        try {
          val destination = File(context.filesDir, filename)
          if (destination.exists()) {
            destination.delete()
          }
          body.byteStream().use { input ->
            destination.outputStream().use { output ->
              input.copyTo(output)
            }
          }
          destination
        } catch (e: Exception) {
          throw DownloadError.FileSystemError(e)
        }
      }
    }
  }

  private suspend fun executeRequest(request: Request): Response =
    suspendCancellableCoroutine { continuation ->
      val call = client.newCall(request)
      continuation.invokeOnCancellation { call.cancel() }
      call.enqueue(object : Callback {
        override fun onFailure(call: Call, e: IOException) {
          continuation.resumeWithException(DownloadError.InvalidResponse)
        }

        override fun onResponse(call: Call, response: Response) {
          if (!response.isSuccessful) {
            Log.d("Download", "Body: ${response.body?.string()}")
          }
          continuation.resume(response)
        }
      })
    }
}