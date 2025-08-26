#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "BugReportingApi.h"
#import "InstabugSDK/IBGBugReporting.h"

@interface BugReportingApiTests : XCTestCase

@property (nonatomic, strong) id mBugReporting;
@property (nonatomic, strong) BugReportingFlutterApi *mFlutterApi;
@property (nonatomic, strong) BugReportingApi *api;

@end

@implementation BugReportingApiTests

- (void)setUp {
    self.mBugReporting = OCMClassMock([IBGBugReporting class]);
    self.mFlutterApi = OCMPartialMock([[BugReportingFlutterApi alloc] init]);
    self.api = [[BugReportingApi alloc] initWithFlutterApi:self.mFlutterApi];
}

- (void)testSetEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mBugReporting setEnabled:YES]);
}

- (void)testShow {
    NSString *reportType = @"ReportType.bug";
    NSArray<NSString *> *invocationOptions = @[@"InvocationOption.emailFieldOptional", @"InvocationOption.disablePostSendingDialog"];
    FlutterError *error;

    [self.api showReportType:reportType invocationOptions:invocationOptions error:&error];

    OCMVerify([self.mBugReporting showWithReportType:IBGBugReportingReportTypeBug options:IBGBugReportingOptionEmailFieldOptional | IBGBugReportingOptionDisablePostSendingDialog]);
}

- (void)testSetInvocationEvents {
    NSArray<NSString *> *events = @[@"InvocationEvent.floatingButton", @"InvocationEvent.screenshot"];
    FlutterError *error;

    [self.api setInvocationEventsEvents:events error:&error];

    OCMVerify([self.mBugReporting setInvocationEvents:IBGInvocationEventFloatingButton | IBGInvocationEventScreenshot]);
}

- (void)testSetReportTypes {
    NSArray<NSString *> *types = @[@"ReportType.bug", @"ReportType.feedback"];
    FlutterError *error;

    [self.api setReportTypesTypes:types error:&error];

    OCMVerify([self.mBugReporting setPromptOptionsEnabledReportTypes:IBGBugReportingReportTypeBug | IBGBugReportingReportTypeFeedback]);
}

- (void)testSetExtendedBugReportingMode {
    NSString *mode = @"ExtendedBugReportMode.enabledWithOptionalFields";
    FlutterError *error;

    [self.api setExtendedBugReportModeMode:mode error:&error];

    OCMVerify([self.mBugReporting setExtendedBugReportMode:IBGExtendedBugReportModeEnabledWithOptionalFields]);
}

- (void)testSetInvocationOptions {
    NSArray<NSString *> *options = @[@"InvocationOption.emailFieldHidden", @"InvocationOption.commentFieldRequired"];
    FlutterError *error;

    [self.api setInvocationOptionsOptions:options error:&error];

    OCMVerify([self.mBugReporting setBugReportingOptions:IBGBugReportingOptionEmailFieldHidden | IBGBugReportingOptionCommentFieldRequired]);
}

- (void)testSetFloatingButtonEdge {
    NSString *edge = @"FloatingButtonEdge.left";
    NSNumber *offset = @100;
    FlutterError *error;

    [self.api setFloatingButtonEdgeEdge:edge offset:offset error:&error];

    OCMVerify([self.mBugReporting setFloatingButtonEdge:@(CGRectMinXEdge).doubleValue]);
    OCMVerify([self.mBugReporting setFloatingButtonTopOffset:offset.doubleValue]);
}

- (void)testSetVideoRecordingFloatingButtonPosition {
    NSString *position = @"Position.topRight";
    FlutterError *error;

    [self.api setVideoRecordingFloatingButtonPositionPosition:position error:&error];

    OCMVerify([self.mBugReporting setVideoRecordingFloatingButtonPosition:IBGPositionTopRight]);
}

- (void)testSetShakingThresholdForiPhone {
    NSNumber *threshold = @300;
    FlutterError *error;

    [self.api setShakingThresholdForiPhoneThreshold:threshold error:&error];

    OCMVerify([self.mBugReporting setShakingThresholdForiPhone:threshold.doubleValue]);
}

- (void)testSetShakingThresholdForiPad {
    NSNumber *threshold = @300;
    FlutterError *error;

    [self.api setShakingThresholdForiPadThreshold:threshold error:&error];

    OCMVerify([self.mBugReporting setShakingThresholdForiPad:threshold.doubleValue]);
}

- (void)testSetEnabledAttachmentTypes {
    NSNumber *screenshot = @1;
    NSNumber *extraScreenshot = @1;
    NSNumber *galleryImage = @1;
    NSNumber *screenRecording = @1;
    FlutterError *error;

    [self.api setEnabledAttachmentTypesScreenshot:screenshot extraScreenshot:extraScreenshot galleryImage:galleryImage screenRecording:screenRecording error:&error];

    OCMVerify([self.mBugReporting setEnabledAttachmentTypes:IBGAttachmentTypeScreenShot | IBGAttachmentTypeExtraScreenShot | IBGAttachmentTypeGalleryImage | IBGAttachmentTypeScreenRecording]);
}

- (void)testBindOnInvokeCallback {
    FlutterError *error;

    [self.api bindOnInvokeCallbackWithError:&error];
    IBGBugReporting.willInvokeHandler();

    OCMVerify([self.mBugReporting setWillInvokeHandler:[OCMArg any]]);
    OCMVerify([self.mFlutterApi onSdkInvokeWithCompletion:[OCMArg invokeBlock]]);
}

- (void)testBindOnDismissCallback {
    IBGDismissType dismissType = IBGDismissTypeSubmit;
    IBGReportType reportType = IBGReportTypeBug;
    FlutterError *error;

    [self.api bindOnDismissCallbackWithError:&error];
    IBGBugReporting.didDismissHandler(dismissType, reportType);

    OCMVerify([self.mBugReporting setDidDismissHandler:[OCMArg any]]);
    OCMVerify([self.mFlutterApi onSdkDismissDismissType:@"SUBMIT" reportType:@"BUG" completion:[OCMArg invokeBlock]]);
}

- (void)testSetDisclaimerText {
    NSString *text = @"My very own disclaimer text";
    FlutterError *error;

    [self.api setDisclaimerTextText:text error:&error];

    OCMVerify([self.mBugReporting setDisclaimerText:text]);
}

- (void)testSetCommentMinimumCharacterCountGivenReportTypes {
    NSNumber *limit = @100;
    NSArray<NSString *> *reportTypes = @[@"ReportType.bug", @"ReportType.question"];
    FlutterError *error;

    [self.api setCommentMinimumCharacterCountLimit:limit reportTypes:reportTypes error:&error];

    OCMVerify([self.mBugReporting setCommentMinimumCharacterCount:limit.intValue forBugReportType:IBGBugReportingReportTypeBug | IBGBugReportingReportTypeQuestion]);
}

- (void)testSetCommentMinimumCharacterCountGivenNoReportTypes {
    NSNumber *limit = @100;
    NSArray<NSString *> *reportTypes = @[];
    FlutterError *error;

    [self.api setCommentMinimumCharacterCountLimit:limit reportTypes:reportTypes error:&error];

    OCMVerify([self.mBugReporting setCommentMinimumCharacterCount:limit.intValue forBugReportType:IBGBugReportingReportTypeBug | IBGBugReportingReportTypeFeedback | IBGBugReportingReportTypeQuestion]);
}
- (void)testAddUserConsentWithKey {
  NSString *key = @"testKey";
  NSString *description = @"Consent description";
  NSNumber *mandatory = @1;
  NSNumber *checked = @0;
  NSString *actionType= @"UserConsentActionType.dropAutoCapturedMedia";
  FlutterError *error;
    IBGActionType mappedActionType =  IBGActionTypeDropAutoCapturedMedia;

  [self.api addUserConsentsKey:key
                                  description:description
                                    mandatory:mandatory
                                      checked:checked
                                   actionType:actionType
                         error: &error
                                   ];
  OCMVerify([self.mBugReporting addUserConsentWithKey:key
                                        description:description
                                          mandatory:[mandatory boolValue]
                                            checked:[checked boolValue]
                                         actionType:mappedActionType]);
}
@end
