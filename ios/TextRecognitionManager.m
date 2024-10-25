#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(TextRecognitionManager, NSObject)

RCT_EXTERN_METHOD(recognizeText:(NSString *)imageBase64
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject)

@end

