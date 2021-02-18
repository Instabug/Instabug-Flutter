//
//  InstabugSampleTests.m
//  InstabugSampleTests
//
//  Created by Ali Abdelfattah on 2/14/21.
//

#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "InstabugFlutterPlugin.h"

@interface InstabugSampleTests : XCTestCase

@end

@implementation InstabugSampleTests

 - (void)testShowWelcomeMessageWithMode {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     id result;

     NSArray *arguments = [NSArray arrayWithObjects:@"WelcomeMessageMode.live", nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"showWelcomeMessageWithMode:" arguments:arguments];
     [[[mock stub] classMethod] showWelcomeMessageWithMode:@"WelcomeMessageMode.live"];
     [instabug  handleMethodCall:call result:result];
     [[[mock verify] classMethod] showWelcomeMessageWithMode:@"WelcomeMessageMode.live"];
 }

 - (void)testIdentifyUserWithEmail {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     id result;

     NSArray *arguments = [NSArray arrayWithObjects:@"test@test.com", @"name", nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"identifyUserWithEmail:name:" arguments:arguments];
     [[[mock stub] classMethod] identifyUserWithEmail:@"test@test.com"name:@"name"];
     [instabug  handleMethodCall:call result:result];
     [[[mock verify] classMethod] identifyUserWithEmail:@"test@test.com"name:@"name"];
 }

 - (void)testLogOut {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     id result;

     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"logOut" arguments:NULL];
     [[[mock stub] classMethod] logOut];
     [instabug  handleMethodCall:call result:result];
     [[[mock verify] classMethod] logOut];
 }

 - (void)testAppendTags {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     id result;

     NSArray *tags = [NSArray arrayWithObjects:@"tag1", @"tag2", nil];
     NSArray *arguments = [NSArray arrayWithObjects: tags, nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"appendTags:" arguments:arguments];
     [[[mock stub] classMethod] appendTags:tags];
     [instabug  handleMethodCall:call result:result];
     [[[mock verify] classMethod] appendTags:tags];
 }

 - (void)testShowBugReportingWithReportTypeAndOptions {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     id result;

     NSArray *options = [NSArray arrayWithObjects:@"commentFieldRequired", @"disablePostSendingDialog", nil];
     NSArray *arguments = [NSArray arrayWithObjects:@"bug", options, nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"showBugReportingWithReportTypeAndOptions:options:" arguments:arguments];
     [[[mock stub] classMethod] showBugReportingWithReportTypeAndOptions:@"bug"options:options];
     [instabug  handleMethodCall:call result:result];
     [[[mock verify] classMethod] showBugReportingWithReportTypeAndOptions:@"bug"options:options];
 }

 - (void)testSetSessionProfilerEnabled {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     id result;

     NSArray *arguments = [NSArray arrayWithObjects:@(1), nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"setSessionProfilerEnabled:" arguments:arguments];
     [[[mock stub] classMethod] setSessionProfilerEnabled:@(1)];
     [instabug  handleMethodCall:call result:result];
     [[[mock verify] classMethod] setSessionProfilerEnabled:@(1)];
 }

 - (void)testSetPrimaryColor {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     id result;

     NSArray *arguments = [NSArray arrayWithObjects:@(1123123123121), nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"setPrimaryColor:" arguments:arguments];
     [[[mock stub] classMethod] setPrimaryColor:@(1123123123121)];
     [instabug  handleMethodCall:call result:result];
     [[[mock verify] classMethod] setPrimaryColor:@(1123123123121)];
 }

 - (void)testAddFileAttachmentWithData {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     id result;

     FlutterStandardTypedData *data;
     NSArray *arguments = [NSArray arrayWithObjects:data, nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"addFileAttachmentWithData:" arguments:arguments];
     [[[mock stub] classMethod] addFileAttachmentWithData:data];
     [instabug  handleMethodCall:call result:result];
     [[[mock verify] classMethod] addFileAttachmentWithData:data];
 }

 - (void)testSetEnabledAttachmentTypes {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     id result;

     NSArray *arguments = [NSArray arrayWithObjects:@(1),@(1),@(1),@(1), nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording:" arguments:arguments];
     [[[mock stub] classMethod] setEnabledAttachmentTypes:@(1) extraScreenShot:@(1) galleryImage:@(1) screenRecording:@(1) ];
     [instabug  handleMethodCall:call result:result];
     [[[mock verify] classMethod] setEnabledAttachmentTypes:@(1) extraScreenShot:@(1) galleryImage:@(1) screenRecording:@(1)];
 }

 - (void)testSetEmailFieldRequiredForFeatureRequests {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     id result;

     NSArray *actions = [NSArray arrayWithObjects:@"reportBug", @"requestNewFeature", nil];
     NSArray *arguments = [NSArray arrayWithObjects:@(1), actions, nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"setEmailFieldRequiredForFeatureRequests:forAction:" arguments:arguments];
     [[[mock stub] classMethod] setEmailFieldRequiredForFeatureRequests:@(1) forAction:actions];
     [instabug  handleMethodCall:call result:result];
     [[[mock verify] classMethod] setEmailFieldRequiredForFeatureRequests:@(1) forAction:actions];
 }


@end
