import { TurboModuleRegistry, type TurboModule } from 'react-native';

/**
 * The native module's spec. Codegen reads it for the New Architecture; on the
 * old architecture the same methods are exported by the bridge module.
 * Apps use `FloadAttribution` from the package root, not this.
 */
export interface Spec extends TurboModule {
  configure(key: string, endpoint: string | null, logLevel: string): void;
  setUserId(userId: string): void;
  getInstallReference(): Promise<string | null>;
}

/** Null where the native code is missing: Expo Go, web, or an app not rebuilt yet. */
export default TurboModuleRegistry.get<Spec>('FloadAttribution');
