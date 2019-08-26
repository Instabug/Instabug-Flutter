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
    XCUIElement *ibgfloatingbuttonaccessibilityidentifierElement = app/*@START_MENU_TOKEN@*/.otherElements[@"IBGFloatingButtonAccessibilityIdentifier"]/*[[".otherElements[@\"Floating Button\"]",".otherElements[@\"IBGFloatingButtonAccessibilityIdentifier\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [ibgfloatingbuttonaccessibilityidentifierElement tap];
    [app.tables/*@START_MENU_TOKEN@*/.staticTexts[@"Report a problem"]/*[[".cells[@\"Report a problem\"].staticTexts[@\"Report a problem\"]",".cells[@\"IBGReportBugPromptOptionAccessibilityIdentifier\"].staticTexts[@\"Report a problem\"]",".staticTexts[@\"Report a problem\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];

    XCUIElement *textField = app.scrollViews.otherElements.textFields[@"IBGBugInputViewEmailFieldAccessibilityIdentifier"];
    [textField tap];
    if (![textField.value  isEqual: @"Enter your email"]) {
        [textField pressForDuration:1.2];
        [app.menuItems[@"Select All"] tap];
    }
    [textField typeText:@"inst@bug.com"];
    [app.navigationBars[@"Report a problem"]/*@START_MENU_TOKEN@*/.buttons[@"IBGBugVCNextButtonAccessibilityIdentifier"]/*[[".buttons[@\"Send\"]",".buttons[@\"IBGBugVCNextButtonAccessibilityIdentifier\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];

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
