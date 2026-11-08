# Changelog

## 1.1.0

- Native SDKs 1.1.0; installs name this wrapper (FLO-3957). Builds on the
  Fload iOS SDK 1.1.0 (vendored in the pod) and the Fload Android SDK 1.1.0
  (JitPack), and every request carries `sdk.wrapper`
  `{name: "react-native", version}` with this package's version.

## 1.0.0

- First release. `FloadAttribution.configure`, `setUserId` and
  `getInstallReference` as a TurboModule (New Architecture) with an old
  architecture bridge module, over the Fload iOS SDK 1.0.2 (vendored in the
  pod) and the Fload Android SDK 1.0.2 (JitPack). Works in Expo development
  builds and prebuild; a no-op with one warning in Expo Go.
