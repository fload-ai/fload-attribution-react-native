package com.fload.attribution.reactnative

import android.content.Context
import android.util.Log
import com.fload.attribution.Fload
import com.fload.attribution.FloadLogLevel
import com.fload.attribution.FloadOptions
import com.fload.attribution.FloadWrapper

/** What both architectures' modules do: map JS arguments to the Fload Android SDK. */
internal object FloadAttributionImpl {
  const val NAME = "FloadAttribution"

  fun configure(context: Context, key: String, endpoint: String?, logLevel: String, wrapperName: String, wrapperVersion: String) {
    Fload.configure(context, key, options(endpoint, logLevel, wrapperName, wrapperVersion))
  }

  /** The SDK's options. The wrapper (this package's name and version, from JS) goes on every request as `sdk.wrapper`. */
  fun options(endpoint: String?, logLevel: String, wrapperName: String, wrapperVersion: String): FloadOptions {
    val level = logLevel(logLevel)
    val wrapper = FloadWrapper(wrapperName, wrapperVersion)
    return if (endpoint.isNullOrEmpty()) {
      FloadOptions(logLevel = level, wrapper = wrapper)
    } else {
      FloadOptions(endpoint = endpoint, logLevel = level, wrapper = wrapper)
    }
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
