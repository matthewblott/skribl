package com.matthewblott.skribl.fragments

import dev.hotwire.navigation.destinations.HotwireDestinationDeepLink
import dev.hotwire.navigation.fragments.HotwireWebFragment
import androidx.activity.result.contract.ActivityResultContracts
import java.io.File
import android.net.Uri

@HotwireDestinationDeepLink(uri = "hotwire://fragment/web")
open class WebFragment : HotwireWebFragment()