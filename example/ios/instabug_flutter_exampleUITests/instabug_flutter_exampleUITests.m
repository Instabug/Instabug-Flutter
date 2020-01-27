//
//  instabug_flutter_exampleUITests.m
//  instabug_flutter_exampleUITests
//
//  Created by Aly Ezz on 8/19/19.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface instabug_flutter_exampleUITests : XCTestCase

@end

@implementation instabug_flutter_exampleUITests

- (void)setUp {
    self.continueAfterFailure = NO;
    [[[XCUIApplication alloc] init] launch];
}

- (void)testInstabugSendBugReport {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app.buttons[@"IBGFloatingButtonAccessibilityIdentifier"] tap];

    [app.tables.staticTexts[@"Report a bug"] tap];

    XCUIElement *textField = app.scrollViews.otherElements.textFields[@"IBGBugInputViewEmailFieldAccessibilityIdentifier"];
    [textField tap];
    if (![textField.value  isEqual: @"Enter your email"]) {
        [textField pressForDuration:1.2];
        [app.menuItems[@"Select All"] tap];
    }
    [textField typeText:@"inst@bug.com"];
    [app.navigationBars[@"Report a bug"]/*@START_MENU_TOKEN@*/.buttons[@"IBGBugVCNextButtonAccessibilityIdentifier"]/*[[".buttons[@\"Send\"]",".buttons[@\"IBGBugVCNextButtonAccessibilityIdentifier\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];

    XCUIElement *element = app.staticTexts[@"Thank you"];
    [self waitForElementToAppear:element withTimeout:5];
}


- (void)waitForElementToAppear:(XCUIElement *)element withTimeout:(NSTimeInterval)timeout
{
    NSUInteger line = __LINE__;
    NSString *file = [NSString stringWithUTF8String:__FILE__];
    NSPredicate *existsPredicate = [NSPredicate predicateWithFormat:@"exists == true"];
    
    [self expectationForPredicate:existsPredicate evaluatedWithObject:element handler:nil];
    
    [self waitForExpectationsWithTimeout:timeout handler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSString *message = [NSString stringWithFormat:@"Failed to find %@ after %f seconds",element,timeout];
            [self recordFailureWithDescription:message inFile:file atLine:line expected:YES];
        }
    }];
}

@end
