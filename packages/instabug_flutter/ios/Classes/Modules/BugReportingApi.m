#import <Flutter/Flutter.h>
#import "InstabugSDK.h"
#import "BugReportingApi.h"
#import "ArgsRegistry.h"

extern void InitBugReportingApi(id<FlutterBinaryMessenger> messenger) {
    BugReportingFlutterApi *flutterApi = [[BugReportingFlutterApi alloc] initWithBinaryMessenger:messenger];
    BugReportingApi *api = [[BugReportingApi alloc] initWithFlutterApi:flutterApi];
    BugReportingHostApiSetup(messenger, api);
}

@implementation BugReportingApi

- (instancetype)initWithFlutterApi:(BugReportingFlutterApi *)api {
    self = [super init];
    self.flutterApi = api;
    return self;
}

- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReporting.enabled = [isEnabled boolValue];
}

- (void)showReportType:(NSString *)reportType invocationOptions:(NSArray<NSString *> *)invocationOptions error:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReportingReportType resolvedType = (ArgsRegistry.reportTypes[reportType]).integerValue;
    IBGBugReportingOption resolvedOptions = 0;

    for (NSString *option in invocationOptions) {
        resolvedOptions |= (ArgsRegistry.invocationOptions[option]).integerValue;
    }

    [IBGBugReporting showWithReportType:resolvedType options:resolvedOptions];
}

- (void)setInvocationEventsEvents:(NSArray<NSString *> *)events error:(FlutterError *_Nullable *_Nonnull)error {
    IBGInvocationEvent resolvedEvents = 0;

    for (NSString *event in events) {
        resolvedEvents |= (ArgsRegistry.invocationEvents[event]).integerValue;
    }

    IBGBugReporting.invocationEvents = resolvedEvents;
}

- (void)setReportTypesTypes:(NSArray<NSString *> *)types error:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReportingReportType resolvedTypes = 0;

    for (NSString *type in types) {
        resolvedTypes |= (ArgsRegistry.reportTypes[type]).integerValue;
    }

    [IBGBugReporting setPromptOptionsEnabledReportTypes:resolvedTypes];
}

- (void)setExtendedBugReportModeMode:(NSString *)mode error:(FlutterError *_Nullable *_Nonnull)error {
    IBGExtendedBugReportMode resolvedMode = (ArgsRegistry.extendedBugReportStates[mode]).integerValue;
    IBGBugReporting.extendedBugReportMode = resolvedMode;
}

- (void)setInvocationOptionsOptions:(NSArray<NSString *> *)options error:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReportingOption resolvedOptions = 0;

    for (NSString *option in options) {
        resolvedOptions |= (ArgsRegistry.invocationOptions[option]).integerValue;
    }

    IBGBugReporting.bugReportingOptions = resolvedOptions;
}

- (void)setFloatingButtonEdgeEdge:(NSString *)edge offset:(NSNumber *)offset error:(FlutterError *_Nullable *_Nonnull)error {
    CGRectEdge resolvedEdge = (ArgsRegistry.floatingButtonEdges[edge]).doubleValue;
    IBGBugReporting.floatingButtonEdge = resolvedEdge;
    IBGBugReporting.floatingButtonTopOffset = [offset doubleValue];
}

- (void)setVideoRecordingFloatingButtonPositionPosition:(NSString *)position error:(FlutterError *_Nullable *_Nonnull)error {
    IBGPosition resolvedPosition = (ArgsRegistry.recordButtonPositions[position]).integerValue;
    IBGBugReporting.videoRecordingFloatingButtonPosition = resolvedPosition;
}

- (void)setShakingThresholdForiPhoneThreshold:(NSNumber *)threshold error:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReporting.shakingThresholdForiPhone = [threshold doubleValue];
}

- (void)setShakingThresholdForiPadThreshold:(NSNumber *)threshold error:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReporting.shakingThresholdForiPad = [threshold doubleValue];
}

- (void)setShakingThresholdForAndroidThreshold:(NSNumber *)threshold error:(FlutterError *_Nullable *_Nonnull)error {
    // Android Only
}

- (void)setEnabledAttachmentTypesScreenshot:(NSNumber *)screenshot extraScreenshot:(NSNumber *)extraScreenshot galleryImage:(NSNumber *)galleryImage screenRecording:(NSNumber *)screenRecording error:(FlutterError *_Nullable *_Nonnull)error {

    IBGAttachmentType resolvedTypes = 0;

    if ([screenshot boolValue]) {
        resolvedTypes |= IBGAttachmentTypeScreenShot;
    }
    if ([extraScreenshot boolValue]) {
        resolvedTypes |= IBGAttachmentTypeExtraScreenShot;
    }
    if ([galleryImage boolValue]) {
        resolvedTypes |= IBGAttachmentTypeGalleryImage;
    }
    if ([screenRecording boolValue]) {
        resolvedTypes |= IBGAttachmentTypeScreenRecording;
    }

    IBGBugReporting.enabledAttachmentTypes = resolvedTypes;
}

- (void)bindOnInvokeCallbackWithError:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReporting.willInvokeHandler = ^{
      [self->_flutterApi onSdkInvokeWithCompletion:^(FlutterError *_Nullable _){
      }];
    };
}

- (void)bindOnDismissCallbackWithError:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReporting.didDismissHandler = ^(IBGDismissType dismissType, IBGReportType reportType) {
      // Parse dismiss type enum
      NSString *dismissTypeString;
      if (dismissType == IBGDismissTypeCancel) {
          dismissTypeString = @"CANCEL";
      } else if (dismissType == IBGDismissTypeSubmit) {
          dismissTypeString = @"SUBMIT";
      } else if (dismissType == IBGDismissTypeAddAttachment) {
          dismissTypeString = @"ADD_ATTACHMENT";
      }

      // Parse report type enum
      NSString *reportTypeString;
      if (reportType == IBGReportTypeBug) {
          reportTypeString = @"BUG";
      } else if (reportType == IBGReportTypeFeedback) {
          reportTypeString = @"FEEDBACK";
      } else {
          reportTypeString = @"OTHER";
      }

      [self->_flutterApi onSdkDismissDismissType:dismissTypeString
                                      reportType:reportTypeString
                                      completion:^(FlutterError *_Nullable _){
                                      }];
    };
}

- (void)setDisclaimerTextText:(NSString *)text error:(FlutterError *_Nullable *_Nonnull)error {
    [IBGBugReporting setDisclaimerText:text];
}

- (void)setCommentMinimumCharacterCountLimit:(NSNumber *)limit reportTypes:(nullable NSArray<NSString *> *)reportTypes error:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReportingType resolvedTypes = 0;
    if (![reportTypes count]) {
        resolvedTypes = (ArgsRegistry.reportTypes[@"ReportType.bug"]).integerValue | (ArgsRegistry.reportTypes[@"ReportType.feedback"]).integerValue | (ArgsRegistry.reportTypes[@"ReportType.question"]).integerValue;
    }
    else {
        for (NSString *reportType in reportTypes) {
            resolvedTypes |= (ArgsRegistry.reportTypes[reportType]).integerValue;
        }
    }
    
    [IBGBugReporting setCommentMinimumCharacterCount:[limit integerValue] forBugReportType:resolvedTypes];
}

- (void)addUserConsentsKey:(NSString *)key
                 description:(NSString *)description
                   mandatory:(NSNumber *)mandatory
                     checked:(NSNumber *)checked
                  actionType:(nullable NSString *)actionType
                       error:(FlutterError *_Nullable *_Nonnull)error {
   
    IBGActionType mappedActionType =  (ArgsRegistry.userConsentActionTypes[actionType]).integerValue;

    [IBGBugReporting addUserConsentWithKey:key
                               description:description
                                 mandatory:[mandatory boolValue]
                                   checked:[checked boolValue]
                                actionType:mappedActionType];
}


@end
