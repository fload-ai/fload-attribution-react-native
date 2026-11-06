package com.fload.attribution.reactnative

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext

internal object Architecture {
  const val IS_NEW = true
}

/** The TurboModule, generated spec from src/NativeFloadAttribution.ts. */
class FloadAttributionModule(reactContext: ReactApplicationContext) :
  NativeFloadAttributionSpec(reactContext) {

  override fun configure(key: String, endpoint: String?, logLevel: String) {
    FloadAttributionImpl.configure(reactApplicationContext, key, endpoint, logLevel)
  }

  override fun setUserId(userId: String) {
    FloadAttributionImpl.setUserId(userId)
  }

  override fun getInstallReference(promise: Promise) {
    promise.resolve(FloadAttributionImpl.installReference())
  }
}
