#ifdef RCT_NEW_ARCH_ENABLED
#import <FloadAttributionSpec/FloadAttributionSpec.h>

@interface FloadAttributionModule : NSObject <NativeFloadAttributionSpec>
@end

#else
#import <React/RCTBridgeModule.h>

@interface FloadAttributionModule : NSObject <RCTBridgeModule>
@end

#endif
