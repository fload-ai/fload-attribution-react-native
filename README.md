# Fload Attribution for React Native

Counts your app's installs in Fload and attributes them: to Apple Ads through
Apple's AdServices API on iOS, and with Google Play's Install Referrer on
Android. No IDFA, no advertising ID, no App Tracking Transparency prompt.

It is a thin TurboModule over Fload's native SDKs,
[iOS](https://github.com/fload-ai/fload-attribution-ios) and
[Android](https://github.com/fload-ai/fload-attribution-android), which do
all the work. It runs on the New Architecture and the old one, in bare React
Native and in Expo development builds.

Needs iOS 15.1+ and Android API 24+, and React Native 0.74 or later.

## Install

```sh
npm install @fload-ai/attribution-react-native
# or: yarn add @fload-ai/attribution-react-native
cd ios && pod install
```

Then rebuild the app. Autolinking adds the native code on both platforms.

**Android:** the Fload Android SDK comes from [JitPack](https://jitpack.io).
React Native's Gradle plugin adds JitPack to every project by default, so
there is nothing to do. If your app sets `includeJitpackRepository=false`,
add `maven("https://jitpack.io")` to your repositories.

### Expo

Use a [development build](https://docs.expo.dev/develop/development-builds/introduction/)
or `npx expo prebuild`. No config plugin is needed:

```sh
npx expo install @fload-ai/attribution-react-native
npx expo run:ios      # or run:android, or an EAS build
```

Expo Go cannot load native code. There the package does nothing and logs one
warning.

## Use

```ts
import { FloadAttribution } from '@fload-ai/attribution-react-native';

// Once, as early as you can (index.js, or before your root component renders):
FloadAttribution.configure('fload_pk_…');

// Optional: link your user id (e.g. RevenueCat's app user id) to the install.
FloadAttribution.setUserId(await Purchases.getAppUserID());
```

The key is your app's public write key from Fload. It can only report
installs for that one app, so it is safe to ship in the binary.

| Call | What it does |
| --- | --- |
| `configure(key, options?)` | Starts the native SDK. Call it once a launch. Returns at once. |
| `setUserId(userId)` | Links a user id to this install. Safe before `configure` and on every launch: the same id is sent once. |
| `getInstallReference()` | A promise of this install's random reference, for Fload support. `null` until the SDK has loaded its state. |

`options` takes `endpoint` (only to test against your own API) and `logLevel`
(`'none'`, `'error'`, `'warning'` (the default), `'info'` or `'debug'`).

## What it does

- On the first launch with the SDK it makes a random install reference and
  reports the install once: app id, version and build, OS version, device
  model, locale and first-launch time. On iOS it adds Apple's AdServices
  attribution token, which Fload swaps with Apple server side. On Android it
  adds what Play's Install Referrer API returns.
- `setUserId` sends your user id with the install, or afterwards in a
  separate request. Each id is sent once.
- Everything waits in a small file queue (excluded from backups) until Fload
  accepts it, across relaunches and network loss, with exponential backoff.
  A retry repeats the same ids, so Fload counts the install once.
- It sends when configured, when the app comes to the foreground and when the
  network comes back. All work runs off the JS and main threads.

Details, and what happens on a refused or revoked key, are in the native
READMEs. It never logs the key, the token, the referrer or the user id.

## Notes

- **Existing users:** the first launch of an app version with the SDK counts
  as an install, for existing users too.
- **Reinstalls** and devices restored from a backup are new installs.
- The **iOS Simulator** has no AdServices token; its installs arrive without
  one. An **Android emulator** with the Play Store reports Play's organic
  referrer (`utm_source=google-play&utm_medium=organic`).

## Privacy

The iOS privacy manifest (`PrivacyInfo.xcprivacy`) ships inside the pod: no
tracking, no tracking domains, no required-reason APIs. Collected, linked to
the user, not used for tracking, for analytics: a device ID (the random
install reference), advertising data (the AdServices token) and a user ID
(only when you call `setUserId`). Declare the same in your App Store privacy
answers. For Google Play's Data safety form, see the
[Android README](https://github.com/fload-ai/fload-attribution-android#google-play-data-safety).

## Testing against your own API

```ts
FloadAttribution.configure(key, { endpoint: 'http://localhost:3001', logLevel: 'debug' });
```

On the Android emulator the host is `http://10.0.2.2:<port>`, and a plain
`http` endpoint needs cleartext allowed for that host.

`tools/ingest-stub.mjs` is a local stand-in for Fload's ingest. It checks each
request against the wire contract and answers `202`. The example app sends
only to it:

```sh
yarn                         # in the repo root
yarn stub                    # the stub, on port 3999
yarn example ios             # or: yarn example android
curl localhost:3999/__requests
```

Unit tests: `yarn test` (the JS layer, with the native module mocked).

## How it is built

- `src/NativeFloadAttribution.ts` is the TurboModule spec that Codegen reads.
- iOS: `ios/FloadAttributionModule.mm` is the module for both architectures.
  It calls a small Swift bridge, and that bridge calls the Fload iOS SDK. The
  SDK's sources are vendored byte for byte under `ios/Vendor/FloadAttribution`
  from a tag of the iOS repo. `yarn vendor:ios` refreshes them and
  `yarn check:vendor` verifies them. Nothing is published to CocoaPods trunk;
  the podspec ships in the npm package.
- Android: `src/newarch` and `src/oldarch` hold the two module classes, and
  `newArchEnabled` picks one. Both call the Fload Android SDK.

## License

License: MIT. See [LICENSE](LICENSE).
