package com.matthewblott.skribl.fragments

import androidx.activity.result.contract.ActivityResultContracts
import dev.hotwire.navigation.fragments.HotwireWebFragment
import java.io.File
import android.net.Uri
import dev.hotwire.navigation.destinations.HotwireDestinationDeepLink

@HotwireDestinationDeepLink(uri = "hotwire://fragment/download")
class DownloadFileFragment : HotwireWebFragment(), DownloadFilePresenter {
  private var pendingFile: File? = null

  private val createDocumentLauncher = registerForActivityResult(
    ActivityResultContracts.CreateDocument("application/zip")
  ) { uri: Uri? ->
    val file = pendingFile
    pendingFile = null
    if (uri != null && file != null) {
      requireContext().contentResolver.openOutputStream(uri)?.use { output ->
        file.inputStream().use { input -> input.copyTo(output) }
      }
    }
  }

  override fun presentSavePicker(file: File) {
    pendingFile = file
    createDocumentLauncher.launch(file.name)
  }
}