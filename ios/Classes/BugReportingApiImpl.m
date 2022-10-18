#import <Flutter/Flutter.h>
#import "Instabug.h"
#import "BugReportingApiImpl.h"
#import "InstabugFlutterPlugin.h"

@implementation BugReportingApiImpl

- (BugReportingApiImpl *)initWithFlutterApi:(BugReportingFlutterApi *)api {
    self = [super init];
    self.flutterApi = api;
    return self;
}

- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [isEnabled boolValue];
    IBGBugReporting.enabled = boolValue;
}

- (void)showReportType:(NSString *)reportType invocationOptions:(NSArray<NSString *> *)invocationOptions error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger options = 0;
    for (NSString * invocationOption in invocationOptions) {
        options |= ((NSNumber *) constants[invocationOption]).integerValue;
    }
    NSInteger reportTypeInt = ((NSNumber *) constants[reportType]).integerValue;
    [IBGBugReporting showWithReportType:reportTypeInt options:options];
}

- (void)setInvocationEventsEvents:(NSArray<NSString *> *)events error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger invocationEvents = 0;
    for (NSString * invocationEvent in events) {
        invocationEvents |= ((NSNumber *) constants[invocationEvent]).integerValue;
    }
    IBGBugReporting.invocationEvents = invocationEvents;
}

- (void)setReportTypesTypes:(NSArray<NSString *> *)types error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger reportTypes = 0;
    for (NSString * reportType in types) {
        reportTypes |= ((NSNumber *) constants[reportType]).integerValue;
    }
   [IBGBugReporting setPromptOptionsEnabledReportTypes: reportTypes];

}

- (void)setExtendedBugReportModeMode:(NSString *)mode error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger extendedBugReportModeInt = ((NSNumber *) constants[mode]).integerValue;
    IBGBugReporting.extendedBugReportMode = extendedBugReportModeInt;
}

- (void)setInvocationOptionsOptions:(NSArray<NSString *> *)options error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger invocationOptions = 0;
    for (NSString * invocationOption in options) {
        invocationOptions |= ((NSNumber *) constants[invocationOption]).integerValue;
    }
    IBGBugReporting.bugReportingOptions = invocationOptions;
}

- (void)setFloatingButtonEdgeEdge:(NSString *)edge offset:(NSNumber *)offset error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    CGRectEdge intFloatingButtonEdge = ((NSNumber *) constants[edge]).doubleValue;
    IBGBugReporting.floatingButtonEdge = intFloatingButtonEdge;
    double offsetFromTop = [offset doubleValue];
    IBGBugReporting.floatingButtonTopOffset = offsetFromTop;
}

- (void)setVideoRecordingFloatingButtonPositionPosition:(NSString *)position error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    IBGPosition intPosition = ((NSNumber *) constants[position]).doubleValue;
    IBGBugReporting.videoRecordingFloatingButtonPosition = intPosition;
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
    IBGAttachmentType attachmentTypes = 0;
      if([screenshot boolValue]) {
          attachmentTypes = IBGAttachmentTypeScreenShot;
      }
      if([extraScreenshot boolValue]) {
          attachmentTypes |= IBGAttachmentTypeExtraScreenShot;
      }
      if([galleryImage boolValue]) {
          attachmentTypes |= IBGAttachmentTypeGalleryImage;
      }
      if([screenRecording boolValue]) {
          attachmentTypes |= IBGAttachmentTypeScreenRecording;
      }

      IBGBugReporting.enabledAttachmentTypes = attachmentTypes;
}

- (void)bindOnInvokeCallbackWithError:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReporting.willInvokeHandler = ^{
        [self->_flutterApi onSdkInvokeWithCompletion:^(NSError * _Nullable _) {}];
    };
}

- (void)bindOnDismissCallbackWithError:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReporting.didDismissHandler = ^(IBGDismissType dismissType, IBGReportType reportType) {
        // Parse dismiss type enum
        NSString* dismissTypeString;
        if (dismissType == IBGDismissTypeCancel) {
            dismissTypeString = @"CANCEL";
        } else if (dismissType == IBGDismissTypeSubmit) {
            dismissTypeString = @"SUBMIT";
        } else if (dismissType == IBGDismissTypeAddAttachment) {
            dismissTypeString = @"ADD_ATTACHMENT";
        }
        
        // Parse report type enum
        NSString* reportTypeString;
        if (reportType == IBGReportTypeBug) {
            reportTypeString = @"bug";
        } else if (reportType == IBGReportTypeFeedback) {
            reportTypeString = @"feedback";
        } else {
            reportTypeString = @"other";
        }
        
        [self->_flutterApi onSdkDismissDismissType:dismissTypeString reportType:reportTypeString completion:^(NSError * _Nullable _) {}];
    };
}

@end
