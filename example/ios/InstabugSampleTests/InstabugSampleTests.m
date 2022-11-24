#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "InstabugApi.h"
#import "Instabug/Instabug.h"

@interface InstabugSampleTests : XCTestCase

@end

@implementation InstabugSampleTests

- (void) testLogout {
    id mInstabug = OCMClassMock([Instabug class]);
    InstabugApi *api = [[InstabugApi alloc] init];
    FlutterError *error;
    
    [api logOutWithError:&error];
    [[[mInstabug verify] classMethod] logOut];
}

- (void) testSetCustomBrandingImage {
    id mInstabug = OCMClassMock([Instabug class]);
    InstabugApi *api = [[InstabugApi alloc] init];
    id mApi = OCMPartialMock(api);
    NSString *lightImage = @"images/light_logo.jpeg";
    NSString *darkImage = @"images/dark_logo.jpeg";
    FlutterError *error;

    OCMStub([mApi getImageForAsset:[OCMArg isKindOfClass:[NSString class]]]).andReturn([UIImage new]);
    
    [api setCustomBrandingImageLight:lightImage dark:darkImage error:&error];
    [[[mInstabug verify] classMethod] setCustomBrandingImage:[OCMArg isKindOfClass:[UIImageAsset class]]];
}

@end
