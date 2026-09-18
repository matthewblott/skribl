package com.matthewblott.skribl.configuration

import com.matthewblott.skribl.R
import dev.hotwire.navigation.navigator.NavigatorConfiguration
import dev.hotwire.navigation.tabs.HotwireBottomTab

val notesTab = HotwireBottomTab(
  title = "Notes",
  iconResId = R.drawable.notes,
  configuration = NavigatorConfiguration(
    name =  "main",
    startLocation = "${Settings.current.url}/${Settings.userId}/notes",
    navigatorHostId = R.id.notes_navigator_host,
  )
)

val newNoteTab = HotwireBottomTab(
  title = "New Note",
  iconResId = R.drawable.note,
  configuration = NavigatorConfiguration(
    name =  "main",
    startLocation = "${Settings.current.url}/${Settings.userId}/notes/new",
    navigatorHostId = R.id.new_note_navigator_host,
  )
)

val settingsTab = HotwireBottomTab(
  title = "Settings",
  iconResId = R.drawable.settings,
  configuration = NavigatorConfiguration(
    name =  "settings",
    startLocation = "${Settings.current.url}/${Settings.userId}/account",
    navigatorHostId = R.id.settings_navigator_host,
  )
)

val mainTabs = listOf(
  notesTab,
  newNoteTab,
  settingsTab,
)
