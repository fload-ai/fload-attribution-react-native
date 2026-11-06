#import "FloadAttributionModule.h"

#if __has_include(<FloadAttributionReactNative/FloadAttributionReactNative-Swift.h>)
#import <FloadAttributionReactNative/FloadAttributionReactNative-Swift.h>
#else
#import "FloadAttributionReactNative-Swift.h"
#endif

// The React Native module "FloadAttribution": a TurboModule on the New
// Architecture, a bridge module on the old one. Both call the Swift bridge.
@implementation FloadAttributionModule

RCT_EXPORT_MODULE(FloadAttribution)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

RCT_EXPORT_METHOD(configure:(NSString *)key endpoint:(NSString * _Nullable)endpoint logLevel:(NSString *)logLevel)
{
  [FloadAttributionBridge configureWithKey:key endpoint:endpoint logLevel:logLevel];
}

RCT_EXPORT_METHOD(setUserId:(NSString *)userId)
{
  [FloadAttributionBridge setUserId:userId];
}

RCT_EXPORT_METHOD(getInstallReference:(RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
  NSString *reference = FloadAttributionBridge.installReference;
  resolve(reference ?: (id)[NSNull null]);
}

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return std::make_shared<facebook::react::NativeFloadAttributionSpecJSI>(params);
}
#endif

@end
