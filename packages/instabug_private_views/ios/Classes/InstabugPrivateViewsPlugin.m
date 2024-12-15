#import "InstabugPrivateViewsPlugin.h"
#import "PrivateViewApi.h"
#import "PrivateViewHostApi.h"
@implementation InstabugPrivateViewsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    PrivateViewApi* privateViewApi = InitPrivateViewApi([registrar messenger],registrar);
    InitPrivateViewApi([registrar messenger], registrar);
    InitPrivateViewHostApi([registrar messenger], privateViewApi);
    
}


@end
