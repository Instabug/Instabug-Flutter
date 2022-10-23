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

@end
