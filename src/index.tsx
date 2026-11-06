import NativeFloadAttribution, { type Spec } from './NativeFloadAttribution';

/** What the native SDK writes to the system log. It never logs the key, the token, the referrer or a user id. */
export type FloadLogLevel = 'none' | 'error' | 'warning' | 'info' | 'debug';

export interface FloadOptions {
  /** Fload's ingest endpoint. Change it only to test against a local or staging API. */
  endpoint?: string;
  /** Defaults to `warning`. */
  logLevel?: FloadLogLevel;
}

/** This package's version. */
export const VERSION = '1.0.0';

const LOG_LEVELS: readonly FloadLogLevel[] = ['none', 'error', 'warning', 'info', 'debug'];

let warnedMissing = false;

function isExpoGo(): boolean {
  const expo = (globalThis as { expo?: { modules?: Record<string, unknown> } }).expo;
  return Boolean(expo?.modules?.ExpoGo);
}

function missingNativeModule(): void {
  if (warnedMissing) return;
  warnedMissing = true;
  console.warn(
    isExpoGo()
      ? '[@fload-ai/attribution-react-native] Expo Go cannot load native code, so Fload attribution is off here. ' +
          'Use a development build (npx expo run:ios / run:android) or an EAS build.'
      : '[@fload-ai/attribution-react-native] The native module is not linked, so Fload attribution is off. ' +
          'Rebuild the app (run pod install on iOS) after adding the package.'
  );
}

function native(): Spec | null {
  if (NativeFloadAttribution == null) missingNativeModule();
  return NativeFloadAttribution ?? null;
}

/**
 * Fload install attribution: Apple's AdServices token on iOS, the Play
 * Install Referrer on Android. No IDFA, no GAID, no tracking prompt.
 *
 * ```ts
 * FloadAttribution.configure('fload_pk_…');
 * FloadAttribution.setUserId(customerInfo.originalAppUserId); // optional
 * ```
 */
export const FloadAttribution = {
  /**
   * Starts the SDK. Call it once, as early as you can (in `index.js` or the
   * root component's first render). It returns at once; the native SDK does
   * the work in the background and keeps it queued until Fload has it.
   *
   * @param key the app's public write key (`fload_pk_…`) from Fload.
   */
  configure(key: string, options: FloadOptions = {}): void {
    const logLevel = options.logLevel ?? 'warning';
    if (!LOG_LEVELS.includes(logLevel)) {
      throw new TypeError(`FloadAttribution.configure: logLevel must be one of ${LOG_LEVELS.join(', ')}`);
    }
    native()?.configure(key, options.endpoint ?? null, logLevel);
  },

  /**
   * Links your app's user id (for example RevenueCat's app user id) to this
   * install. Safe before `configure` and on every launch: the same id is sent once.
   */
  setUserId(userId: string): void {
    native()?.setUserId(userId);
  },

  /**
   * This install's random reference, for Fload support. Null before
   * `configure` has loaded the SDK's state, and where the native module is missing.
   */
  async getInstallReference(): Promise<string | null> {
    const module = native();
    return module ? module.getInstallReference() : null;
  },
};

export default FloadAttribution;
