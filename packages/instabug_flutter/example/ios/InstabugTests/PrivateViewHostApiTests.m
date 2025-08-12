#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PrivateViewApi.h"
#import "InstabugApi.h"
#import "PrivateViewHostApi.h"

@interface PrivateViewHostApiTests : XCTestCase

@property (nonatomic, strong) PrivateViewHostApi *api;
@property (nonatomic, strong) id privateViewApiMock;

@end

@implementation PrivateViewHostApiTests

- (void)setUp {
    [super setUp];
    
    // Set up a mock for PrivateViewApi
    self.privateViewApiMock = OCMClassMock([PrivateViewApi class]);
    
    // Initialize the PrivateViewHostApi instance
    self.api = [[PrivateViewHostApi alloc] init];
    self.api.privateViewApi = self.privateViewApiMock;
}

- (void)tearDown {
    self.api = nil;
    self.privateViewApiMock = nil;
    [super tearDown];
}

- (void)testInitWithError_setsScreenshotMaskingHandler {
    // Define an expectation for the screenshot masking handler
    UIImage *mockScreenshot = [[UIImage alloc] init];
    UIImage *mockMaskedImage = [[UIImage alloc] init];
    FlutterError *error = nil;


    
    OCMStub([self.privateViewApiMock mask:mockScreenshot completion:([OCMArg invokeBlockWithArgs:mockMaskedImage, nil])]);
    

    // Call initWithError and set up the screenshot masking handler
    [self.api initWithError:&error];

    // Invoke the screenshot masking handler
    void (^completionHandler)(UIImage * _Nullable) = ^(UIImage * _Nullable maskedImage) {
        XCTAssertEqual(maskedImage, mockMaskedImage, @"The masked image should be returned by the completion handler.");
    };
    [InstabugApi setScreenshotMaskingHandler:^(UIImage * _Nonnull screenshot, void (^ _Nonnull completion)(UIImage * _Nullable)) {
        completionHandler(screenshot);
    }];
}

@end
