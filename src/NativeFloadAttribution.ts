import { TurboModuleRegistry, type TurboModule } from 'react-native';

/**
 * The native module's spec. Codegen reads it for the New Architecture; on the
 * old architecture the same methods are exported by the bridge module.
 * Apps use `FloadAttribution` from the package root, not this.
 */
export interface Spec extends TurboModule {
  /** `wrapperName` and `wrapperVersion` name this package to Fload (`sdk.wrapper`). */
  configure(key: string, endpoint: string | null, logLevel: string, wrapperName: string, wrapperVersion: string): void;
  setUserId(userId: string): void;
  getInstallReference(): Promise<string | null>;
}

/** Null where the native code is missing: Expo Go, web, or an app not rebuilt yet. */
export default TurboModuleRegistry.get<Spec>('FloadAttribution');
