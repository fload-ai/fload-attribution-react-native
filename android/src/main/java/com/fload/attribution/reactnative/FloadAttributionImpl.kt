package com.fload.attribution.reactnative

import android.content.Context
import android.util.Log
import com.fload.attribution.Fload
import com.fload.attribution.FloadLogLevel
import com.fload.attribution.FloadOptions

/** What both architectures' modules do: map JS arguments to the Fload Android SDK. */
internal object FloadAttributionImpl {
  const val NAME = "FloadAttribution"

  fun configure(context: Context, key: String, endpoint: String?, logLevel: String) {
    val level = logLevel(logLevel)
    val options = if (endpoint.isNullOrEmpty()) {
      FloadOptions(logLevel = level)
    } else {
      FloadOptions(endpoint = endpoint, logLevel = level)
    }
    Fload.configure(context, key, options)
  }

  fun setUserId(userId: String) {
    Fload.setUserId(userId)
  }

  fun installReference(): String? = Fload.installReference

  fun logLevel(name: String): FloadLogLevel = when (name) {
    "none" -> FloadLogLevel.NONE
    "error" -> FloadLogLevel.ERROR
    "info" -> FloadLogLevel.INFO
    "debug" -> FloadLogLevel.DEBUG
    "warning" -> FloadLogLevel.WARNING
    else -> {
      Log.w("FloadAttribution", "Unknown logLevel; using warning.")
      FloadLogLevel.WARNING
    }
  }
}
