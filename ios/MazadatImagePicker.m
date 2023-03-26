#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(MazadatImagePicker, NSObject)

RCT_EXTERN_METHOD(openCamera:(int)length lang:(NSString *)lang
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(editPhoto:(NSString *)path lang:(NSString *)lang
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(openIdVerification:(NSString *)lang
                 resolve:(RCTPromiseResolveBlock)resolve
                 reject:(RCTPromiseRejectBlock)reject)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
