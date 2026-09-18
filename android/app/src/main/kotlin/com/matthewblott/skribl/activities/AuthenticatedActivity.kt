package com.matthewblott.skribl.activities

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.view.View
import androidx.activity.viewModels
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.matthewblott.skribl.R
import com.matthewblott.skribl.configuration.AuthenticatedActivityViewModel
import com.matthewblott.skribl.configuration.mainTabs
import dev.hotwire.navigation.tabs.HotwireBottomNavigationController
import dev.hotwire.navigation.tabs.navigatorConfigurations
import dev.hotwire.navigation.util.applyDefaultImeWindowInsets
import kotlin.getValue

class AuthenticatedActivity : BaseHotwireActivity() {
  lateinit var bottomNavigationController: HotwireBottomNavigationController
  private val viewModel: AuthenticatedActivityViewModel by viewModels()
  
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    setContentView(R.layout.activity_authenticated)
    findViewById<View>(R.id.authenticated_nav_host).applyDefaultImeWindowInsets()
    initializeBottomNavigationView()
  }

  fun launchUnauthenticatedActivity() {
    startActivity(Intent(this as Context, UnauthenticatedActivity::class.java))
    finish() // kill SignInActivity
  }
  
  override fun navigatorConfigurations() = mainTabs.navigatorConfigurations
  
  private fun initializeBottomNavigationView(){
    val bottomNavigationView = findViewById<BottomNavigationView>(R.id.bottom_nav)
    bottomNavigationController = HotwireBottomNavigationController(this, bottomNavigationView)
    bottomNavigationController.load(mainTabs, 0)
    bottomNavigationController.setOnTabSelectedListener { index, _ ->
      viewModel.selectedTabIndex = index
    }
  }
}
