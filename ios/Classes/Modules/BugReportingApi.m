#import <Flutter/Flutter.h>
#import "Instabug.h"
#import "BugReportingApi.h"
#import "ArgsRegistry.h"

@implementation BugReportingApi

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)messenger {
    self = [super init];
    self.flutterApi = [[BugReportingFlutterApi alloc] initWithBinaryMessenger:messenger];
    BugReportingHostApiSetup(messenger, self);
    return self;
}

- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReporting.enabled = [isEnabled boolValue];
}

- (void)showReportType:(NSString *)reportType invocationOptions:(NSArray<NSString *> *)invocationOptions error:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReportingReportType resolvedType = (ArgsRegistry.reportTypes[reportType]).integerValue;
    IBGBugReportingOption resolvedOptions = 0;

    for (NSString * option in invocationOptions) {
        resolvedOptions |= (ArgsRegistry.invocationOptions[option]).integerValue;
    }
    
    [IBGBugReporting showWithReportType:resolvedType options:resolvedOptions];
}

- (void)setInvocationEventsEvents:(NSArray<NSString *> *)events error:(FlutterError *_Nullable *_Nonnull)error {
    IBGInvocationEvent resolvedEvents = 0;
    
    for (NSString * event in events) {
        resolvedEvents |= (ArgsRegistry.invocationEvents[event]).integerValue;
    }
    
    IBGBugReporting.invocationEvents = resolvedEvents;
}

- (void)setReportTypesTypes:(NSArray<NSString *> *)types error:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReportingReportType resolvedTypes = 0;
    
    for (NSString * type in types) {
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

    for (NSString * option in options) {
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
        [self->_flutterApi onSdkInvokeWithCompletion:^(NSError * _Nullable _) {}];
    };
}

- (void)bindOnDismissCallbackWithError:(FlutterError *_Nullable *_Nonnull)error {
    IBGBugReporting.didDismissHandler = ^(IBGDismissType dismissType, IBGReportType reportType) {
        NSString* dismissEnumName = [[ArgsRegistry.dismissTypes allKeysForObject:@(dismissType)] objectAtIndex:0];

        NSString* reportEnumName = [[ArgsRegistry.reportTypes allKeysForObject:@(reportType)] objectAtIndex:0];
        
        [self->_flutterApi onSdkDismissDismissType:dismissEnumName reportType:reportEnumName completion:^(NSError * _Nullable _) {}];
    };
}

@end
