package com.matthewblott.skribl.fragments

import java.io.File

interface DownloadFilePresenter {
  fun presentSavePicker(file: File)
}
