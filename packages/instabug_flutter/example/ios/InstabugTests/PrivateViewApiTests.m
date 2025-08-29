#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import <PrivateViewApi.h>
#import <Flutter/Flutter.h>
#import "FlutterPluginRegistrar+FlutterEngine.h"


@interface MockFlutterPluginRegistrar : NSObject <FlutterPluginRegistrar>
@end

@implementation MockFlutterPluginRegistrar

@end


@interface PrivateViewApiTests : XCTestCase
@property (nonatomic, strong) PrivateViewApi *api;
@property (nonatomic, strong) id mockFlutterApi;
@property (nonatomic, strong) id mockRegistrar;
@property (nonatomic, strong) id mockFlutterViewController;
@property (nonatomic, strong) id mockEngine;

@end

@implementation PrivateViewApiTests

#pragma mark - Setup / Teardown

- (void)setUp {
    [super setUp];

    
    self.mockFlutterApi = OCMClassMock([InstabugPrivateViewFlutterApi class]);


    MockFlutterPluginRegistrar *mockRegistrar = [[MockFlutterPluginRegistrar alloc] init];

    self.mockRegistrar = OCMPartialMock(mockRegistrar);

    self.mockEngine = OCMClassMock([FlutterEngine class]);
        OCMStub([self.mockRegistrar flutterEngine]).andReturn(self.mockEngine);

        self.mockFlutterViewController = OCMClassMock([UIViewController class]);

    OCMStub([self.mockEngine viewController]).andReturn(_mockFlutterViewController);
    
    self.api = OCMPartialMock([[PrivateViewApi alloc] initWithFlutterApi:self.mockFlutterApi registrar: self.mockRegistrar]);
}

- (void)tearDown {
    [self.mockFlutterApi stopMocking];
    [self.mockRegistrar stopMocking];
    [self.mockFlutterViewController stopMocking];
    [self.mockEngine stopMocking];

    self.api = nil;
    
    [super tearDown];
}

#pragma mark - Tests

- (void)testMask_Success {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Mask method success"];
    
    CGSize imageSize = CGSizeMake(100, 100); // 100x100 pixels

       // Step 2: Create the image using UIGraphicsImageRenderer
       UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:imageSize];

       UIImage *screenshot = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
           // Draw a red rectangle as an example
           [[UIColor redColor] setFill];
           CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
           UIRectFill(rect);
       }];
    
    NSArray<NSNumber *> *rectangles = @[@10, @20, @30, @40];
    UIView *mockView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 30, 40)];
    
    OCMStub([self.mockFlutterApi getPrivateViewsWithCompletion:([OCMArg invokeBlockWithArgs:rectangles, [NSNull null], nil])]);
    
        
  
    OCMStub([self.mockFlutterViewController view]).andReturn(mockView);


    [self.api mask:screenshot completion:^(UIImage *result) {
        XCTAssertNotNil(result, @"Masked image should be returned.");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:1 handler:nil];
}


- (void)testGetFlutterViewOrigin_ValidView {
    UIView *mockView = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 100, 100)];
   
    OCMStub([self.mockFlutterViewController view]).andReturn(mockView);
    
    UIWindow*  testWindow = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [testWindow addSubview:mockView];

    CGPoint origin = [self.api getFlutterViewOrigin];
    
    XCTAssertEqual(origin.x, 10);
    XCTAssertEqual(origin.y, 20);
}

- (void)testGetFlutterViewOrigin_NilView {
    
    OCMStub([self.mockFlutterViewController view]).andReturn(nil);
//
    CGPoint origin = [self.api getFlutterViewOrigin];
    
    XCTAssertEqual(origin.x, 0);
    XCTAssertEqual(origin.y, 0);
}

- (void)testDrawMaskedImage {
    CGSize size = CGSizeMake(100, 100);
    UIGraphicsBeginImageContext(size);
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSArray<NSValue *> *privateViews = @[
        [NSValue valueWithCGRect:CGRectMake(10, 10, 20, 20)],
        [NSValue valueWithCGRect:CGRectMake(30, 30, 10, 10)]
    ];
    
    UIImage *result = [self.api drawMaskedImage:screenshot withPrivateViews:privateViews];
    
    XCTAssertNotNil(result);
    XCTAssertEqual(result.size.width, 100);
    XCTAssertEqual(result.size.height, 100);
}

- (void)testConvertToRectangles_ValidInput {
    NSArray<NSNumber *> *rectangles = @[@10, @20, @30, @40];
    UIView *mockView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, 100, 100)];
    OCMStub([self.mockFlutterViewController view]).andReturn(mockView);

    
    NSArray<NSValue *> *converted = [self.api convertToRectangles:rectangles];
    
    XCTAssertEqual(converted.count, 1);
    CGRect rect = [converted[0] CGRectValue];
    XCTAssertTrue(CGRectEqualToRect(rect, CGRectMake(10, 20, 21, 21)));
}

- (void)testConcurrentMaskCalls {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Handle concurrent calls"];
    
    CGSize imageSize = CGSizeMake(100, 100); // 100x100 pixels

       // Step 2: Create the image using UIGraphicsImageRenderer
       UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:imageSize];

       UIImage *screenshot = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
           // Draw a red rectangle as an example
           [[UIColor redColor] setFill];
           CGRect rect = CGRectMake(0, 0, imageSize.width, imageSize.height);
           UIRectFill(rect);
       }];
    
    NSArray<NSNumber *> *rectangles = @[@10, @20, @30, @40];
    
    
    OCMStub([self.mockFlutterApi getPrivateViewsWithCompletion:([OCMArg invokeBlockWithArgs:rectangles, [NSNull null], nil])]);
    
    
    dispatch_group_t group = dispatch_group_create();
    
    for (int i = 0; i < 5; i++) {
        dispatch_group_enter(group);
        
        [self.api mask:screenshot completion:^(UIImage *result) {
            XCTAssertNotNil(result, @"Each call should return a valid image.");
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [expectation fulfill];
    });
    
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

@end
