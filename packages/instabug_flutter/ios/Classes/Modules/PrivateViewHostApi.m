//
//  PrivateViewHostApi.m
//  instabug_flutter
//
//  Created by Ahmed alaa on 02/11/2024.
//

#import "PrivateViewHostApi.h"
#import "instabug_flutter/InstabugApi.h"

extern void InitPrivateViewHostApi(id<FlutterBinaryMessenger> _Nonnull messenger, PrivateViewApi * _Nonnull privateViewApi) {
    PrivateViewHostApi *api = [[PrivateViewHostApi alloc] init];
    api.privateViewApi = privateViewApi;
    InstabugPrivateViewHostApiSetup(messenger, api);
}

@implementation PrivateViewHostApi


- (void)initWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [InstabugApi setScreenshotMaskingHandler:^(UIImage * _Nonnull screenshot, void (^ _Nonnull completion)(UIImage * _Nullable)) {
        
        

           [self.privateViewApi mask:screenshot completion:^(UIImage * _Nonnull maskedImage) {
             if (maskedImage != nil) {
                 completion(maskedImage);
                }
           }];
       }];
}

@end
