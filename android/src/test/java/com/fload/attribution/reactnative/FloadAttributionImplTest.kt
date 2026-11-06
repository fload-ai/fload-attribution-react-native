package com.fload.attribution.reactnative

import com.fload.attribution.FloadLogLevel
import org.junit.Assert.assertEquals
import org.junit.Test

class FloadAttributionImplTest {
  @Test
  fun everyJsLogLevelMapsToTheSdks() {
    val expected = mapOf(
      "none" to FloadLogLevel.NONE,
      "error" to FloadLogLevel.ERROR,
      "warning" to FloadLogLevel.WARNING,
      "info" to FloadLogLevel.INFO,
      "debug" to FloadLogLevel.DEBUG,
    )
    expected.forEach { (name, level) -> assertEquals(name, level, FloadAttributionImpl.logLevel(name)) }
  }

  @Test
  fun anUnknownLogLevelFallsBackToWarning() {
    assertEquals(FloadLogLevel.WARNING, FloadAttributionImpl.logLevel("verbose"))
  }

  @Test
  fun theModuleNameMatchesTheJsSpec() {
    assertEquals("FloadAttribution", FloadAttributionImpl.NAME)
  }
}
