
#import "FlutterPluginRegistrar+FlutterEngine.h"

@implementation NSObject (FlutterEngineAccess)

- (FlutterEngine *)flutterEngine {
    if ([self respondsToSelector:@selector(engine)]) {
        return (FlutterEngine *)[self performSelector:@selector(engine)];
    }
    return nil;
}

@end
