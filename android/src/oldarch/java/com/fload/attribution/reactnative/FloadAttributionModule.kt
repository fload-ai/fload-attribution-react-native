package com.fload.attribution.reactnative

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

internal object Architecture {
  const val IS_NEW = false
}

/** The bridge module for the old architecture: the same methods as the TurboModule spec. */
class FloadAttributionModule(reactContext: ReactApplicationContext) :
  ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String = FloadAttributionImpl.NAME

  @ReactMethod
  fun configure(key: String, endpoint: String?, logLevel: String, wrapperName: String, wrapperVersion: String) {
    FloadAttributionImpl.configure(reactApplicationContext, key, endpoint, logLevel, wrapperName, wrapperVersion)
  }

  @ReactMethod
  fun setUserId(userId: String) {
    FloadAttributionImpl.setUserId(userId)
  }

  @ReactMethod
  fun getInstallReference(promise: Promise) {
    promise.resolve(FloadAttributionImpl.installReference())
  }
}
