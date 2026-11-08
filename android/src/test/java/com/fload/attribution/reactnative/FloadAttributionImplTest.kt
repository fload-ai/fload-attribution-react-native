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
  fun optionsNameTheWrapperAndTheVersionJsSends() {
    val options = FloadAttributionImpl.options(null, "debug", "react-native", "1.1.0")
    assertEquals("react-native", options.wrapper?.name)
    assertEquals("1.1.0", options.wrapper?.version)
    assertEquals("https://ingest.fload.com", options.endpoint)
    assertEquals(FloadLogLevel.DEBUG, options.logLevel)
  }

  @Test
  fun optionsWithAnEndpointNameTheWrapperToo() {
    val options = FloadAttributionImpl.options("http://10.0.2.2:3999", "warning", "react-native", "1.1.0")
    assertEquals("http://10.0.2.2:3999", options.endpoint)
    assertEquals("react-native", options.wrapper?.name)
    assertEquals("1.1.0", options.wrapper?.version)
  }

  @Test
  fun anEmptyEndpointMeansFloads() {
    assertEquals("https://ingest.fload.com", FloadAttributionImpl.options("", "warning", "react-native", "1.1.0").endpoint)
  }

  @Test
  fun theModuleNameMatchesTheJsSpec() {
    assertEquals("FloadAttribution", FloadAttributionImpl.NAME)
  }
}
