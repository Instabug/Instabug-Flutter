#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import <Flutter/Flutter.h>
#import "Instabug.h"
#import "IBGNetworkLogger+CP.h"
#import "InstabugApi.h"
#import "ArgsRegistry.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:((float)((rgbValue & 0xFF000000) >> 24)) / 255.0];

extern void InitInstabugApi(id<FlutterBinaryMessenger> messenger) {
    InstabugApi *api = [[InstabugApi alloc] init];
    InstabugHostApiSetup(messenger, api);
}

@implementation InstabugApi

- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    Instabug.enabled = [isEnabled boolValue];
}

- (void)initToken:(NSString *)token invocationEvents:(NSArray<NSString *> *)invocationEvents debugLogsLevel:(NSString *)debugLogsLevel error:(FlutterError *_Nullable *_Nonnull)error {
    SEL setPrivateApiSEL = NSSelectorFromString(@"setCurrentPlatform:");
    if ([[Instabug class] respondsToSelector:setPrivateApiSEL]) {
        NSInteger *platformID = IBGPlatformFlutter;
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[Instabug class] methodSignatureForSelector:setPrivateApiSEL]];
        [inv setSelector:setPrivateApiSEL];
        [inv setTarget:[Instabug class]];
        [inv setArgument:&(platformID) atIndex:2];
        [inv invoke];
    }
    
    // Disable automatic capturing of native iOS network logs to avoid duplicate
    // logs of the same request when using a native network client like cupertino_http
    [IBGNetworkLogger disableAutomaticCapturingOfNetworkLogs];

    IBGInvocationEvent resolvedEvents = 0;

    for (NSString *event in invocationEvents) {
        resolvedEvents |= (ArgsRegistry.invocationEvents[event]).integerValue;
    }

    IBGSDKDebugLogsLevel resolvedLogLevel = (ArgsRegistry.sdkLogLevels[debugLogsLevel]).integerValue;

    [Instabug setSdkDebugLogsLevel:resolvedLogLevel];
    [Instabug startWithToken:token invocationEvents:resolvedEvents];
}

- (void)showWithError:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug show];
}

- (void)showWelcomeMessageWithModeMode:(NSString *)mode error:(FlutterError *_Nullable *_Nonnull)error {
    IBGWelcomeMessageMode resolvedMode = (ArgsRegistry.welcomeMessageStates[mode]).integerValue;
    [Instabug showWelcomeMessageWithMode:resolvedMode];
}

- (void)identifyUserEmail:(NSString *)email name:(nullable NSString *)name userId:(nullable NSString *)userId error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug identifyUserWithID:userId email:email name:name];
}

- (void)setUserDataData:(NSString *)data error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug setUserData:data];
}

- (void)logUserEventName:(NSString *)name error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug logUserEventWithName:name];
}

- (void)logOutWithError:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug logOut];
}

- (void)setLocaleLocale:(NSString *)locale error:(FlutterError *_Nullable *_Nonnull)error {
    IBGLocale resolvedLocale = (ArgsRegistry.locales[locale]).integerValue;
    [Instabug setLocale:resolvedLocale];
}

- (void)setColorThemeTheme:(NSString *)theme error:(FlutterError *_Nullable *_Nonnull)error {
    IBGColorTheme resolvedTheme = (ArgsRegistry.colorThemes[theme]).integerValue;
    [Instabug setColorTheme:resolvedTheme];
}

- (void)setWelcomeMessageModeMode:(NSString *)mode error:(FlutterError *_Nullable *_Nonnull)error {
    IBGWelcomeMessageMode resolvedMode = (ArgsRegistry.welcomeMessageStates[mode]).integerValue;
    [Instabug setWelcomeMessageMode:resolvedMode];
}

- (void)setPrimaryColorColor:(NSNumber *)color error:(FlutterError *_Nullable *_Nonnull)error {
    Instabug.tintColor = UIColorFromRGB([color longValue]);
}

- (void)setSessionProfilerEnabledEnabled:(NSNumber *)enabled error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug setSessionProfilerEnabled:[enabled boolValue]];
}

- (void)setValueForStringWithKeyValue:(NSString *)value key:(NSString *)key error:(FlutterError *_Nullable *_Nonnull)error {
    if ([ArgsRegistry.placeholders objectForKey:key]) {
        NSString *resolvedKey = ArgsRegistry.placeholders[key];
        [Instabug setValue:value forStringWithKey:resolvedKey];
    }
    else {
        NSString *logMessage = [NSString stringWithFormat: @"%@%@%@", @"Instabug: ", key,  @" is only relevant to Android."];
        NSLog(@"%@", logMessage);
    }
}

- (void)appendTagsTags:(NSArray<NSString *> *)tags error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug appendTags:tags];
}

- (void)resetTagsWithError:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug resetTags];
}

- (void)getTagsWithCompletion:(nonnull void (^)(NSArray<NSString *> * _Nullable, FlutterError * _Nullable))completion {
    completion([Instabug getTags], nil);
}

- (void)addExperimentsExperiments:(NSArray<NSString *> *)experiments error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug addExperiments:experiments];
}

- (void)removeExperimentsExperiments:(NSArray<NSString *> *)experiments error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug removeExperiments:experiments];
}

- (void)clearAllExperimentsWithError:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug clearAllExperiments];
}

- (void)setUserAttributeValue:(NSString *)value key:(NSString *)key error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug setUserAttribute:value withKey:key];
}

- (void)removeUserAttributeKey:(NSString *)key error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug removeUserAttributeForKey:key];
}

- (void)getUserAttributeForKeyKey:(nonnull NSString *)key completion:(nonnull void (^)(NSString * _Nullable, FlutterError * _Nullable))completion {
    completion([Instabug userAttributeForKey:key], nil);
}

- (void)getUserAttributesWithCompletion:(nonnull void (^)(NSDictionary<NSString *,NSString *> * _Nullable, FlutterError * _Nullable))completion {
    completion(Instabug.userAttributes, nil);
}

- (void)setReproStepsConfigBugMode:(nullable NSString *)bugMode crashMode:(nullable NSString *)crashMode sessionReplayMode:(nullable NSString *)sessionReplayMode error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    if (bugMode != nil) {
        IBGUserStepsMode resolvedBugMode = ArgsRegistry.reproModes[bugMode].integerValue;
        [Instabug setReproStepsFor:IBGIssueTypeBug withMode:resolvedBugMode];
    }
    
    if (crashMode != nil) {
        IBGUserStepsMode resolvedCrashMode = ArgsRegistry.reproModes[crashMode].integerValue;
        [Instabug setReproStepsFor:IBGIssueTypeCrash withMode:resolvedCrashMode];
    }
    
    if (sessionReplayMode != nil) {
        IBGUserStepsMode resolvedSessionReplayMode = ArgsRegistry.reproModes[sessionReplayMode].integerValue;
        [Instabug setReproStepsFor:IBGIssueTypeSessionReplay withMode:resolvedSessionReplayMode];
    }
}

- (UIImage *)getImageForAsset:(NSString *)assetName {
    NSString *key = [FlutterDartProject lookupKeyForAsset:assetName];
    NSString *path = [[NSBundle mainBundle] pathForResource:key ofType:nil];

    return [UIImage imageWithContentsOfFile:path];
}

- (void)setCustomBrandingImageLight:(NSString *)light dark:(NSString *)dark error:(FlutterError * _Nullable __autoreleasing *)error {
    UIImage *lightImage = [self getImageForAsset:light];
    UIImage *darkImage = [self getImageForAsset:dark];

    if (!lightImage) {
        lightImage = darkImage;
    }
    if (!darkImage) {
        darkImage = lightImage;
    }

    if (@available(iOS 12.0, *)) {
        UIImageAsset *imageAsset = [[UIImageAsset alloc] init];

        [imageAsset registerImage:lightImage withTraitCollection:[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleLight]];
        [imageAsset registerImage:darkImage withTraitCollection:[UITraitCollection traitCollectionWithUserInterfaceStyle:UIUserInterfaceStyleDark]];

        Instabug.customBrandingImage = imageAsset;
    } else {
        UIImage *defaultImage = lightImage;
        if (!lightImage) {
            defaultImage = darkImage;
        }

        Instabug.customBrandingImage = defaultImage.imageAsset;
    }
}

- (void)reportScreenChangeScreenName:(NSString *)screenName error:(FlutterError *_Nullable *_Nonnull)error {
    SEL setPrivateApiSEL = NSSelectorFromString(@"logViewDidAppearEvent:");
    if ([[Instabug class] respondsToSelector:setPrivateApiSEL]) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[Instabug class] methodSignatureForSelector:setPrivateApiSEL]];
        [inv setSelector:setPrivateApiSEL];
        [inv setTarget:[Instabug class]];
        [inv setArgument:&(screenName) atIndex:2];
        [inv invoke];
    }
}

- (UIFont *)getFontForAsset:(NSString *)assetName  error:(FlutterError *_Nullable *_Nonnull)error {
    NSString *key = [FlutterDartProject lookupKeyForAsset:assetName];
    NSString *path = [[NSBundle mainBundle] pathForResource:key ofType:nil];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    CFErrorRef fontError;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef) data);
    CGFontRef cgFont = CGFontCreateWithDataProvider(provider);
    UIFont *font;

    if(!CTFontManagerRegisterGraphicsFont(cgFont, &fontError)){
        CFStringRef errorDescription = CFErrorCopyDescription(fontError);
        *error = [FlutterError errorWithCode:@"IBGFailedToLoadFont" message:(__bridge NSString *)errorDescription details:nil];
        CFRelease(errorDescription);
    } else {
        NSString *fontName = (__bridge NSString *)CGFontCopyFullName(cgFont);
        font = [UIFont fontWithName:fontName size:10.0];
    }

    if (cgFont) CFRelease(cgFont);
    if (provider) CFRelease(provider);

    return font;
}

- (void)setFontFont:(NSString *)fontAsset error:(FlutterError *_Nullable *_Nonnull)error {
    UIFont *font = [self getFontForAsset:fontAsset error:error];
    Instabug.font = font;
}

- (void)addFileAttachmentWithURLFilePath:(NSString *)filePath fileName:(NSString *)fileName error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug addFileAttachmentWithURL:[NSURL URLWithString:filePath]];
}

- (void)addFileAttachmentWithDataData:(FlutterStandardTypedData *)data fileName:(NSString *)fileName error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug addFileAttachmentWithData:[data data]];
}

- (void)clearFileAttachmentsWithError:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug clearFileAttachments];
}

- (void)networkLogData:(NSDictionary<NSString *, id> *)data error:(FlutterError *_Nullable *_Nonnull)error {
    NSString *url = data[@"url"];
    NSString *method = data[@"method"];
    NSString *requestBody = data[@"requestBody"];
    NSString *responseBody = data[@"responseBody"];
    int32_t responseCode = [data[@"responseCode"] integerValue];
    int64_t requestBodySize = [data[@"requestBodySize"] integerValue];
    int64_t responseBodySize = [data[@"responseBodySize"] integerValue];
    int32_t errorCode = [data[@"errorCode"] integerValue];
    NSString *errorDomain = data[@"errorDomain"];
    NSDictionary *requestHeaders = data[@"requestHeaders"];
    if ([requestHeaders count] == 0) {
        requestHeaders = @{};
    }
    NSDictionary *responseHeaders = data[@"responseHeaders"];
    NSString *contentType = data[@"responseContentType"];
    int64_t duration = [data[@"duration"] integerValue];
    int64_t startTime = [data[@"startTime"] integerValue] * 1000;

    NSString *gqlQueryName = nil;
    NSString *serverErrorMessage = nil;
    if (data[@"gqlQueryName"] != [NSNull null]) {
        gqlQueryName = data[@"gqlQueryName"];
    }
    if (data[@"serverErrorMessage"] != [NSNull null]) {
        serverErrorMessage = data[@"serverErrorMessage"];
    }

    SEL networkLogSEL = NSSelectorFromString(@"addNetworkLogWithUrl:method:requestBody:requestBodySize:responseBody:responseBodySize:responseCode:requestHeaders:responseHeaders:contentType:errorDomain:errorCode:startTime:duration:gqlQueryName:serverErrorMessage:");

    if ([[IBGNetworkLogger class] respondsToSelector:networkLogSEL]) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[IBGNetworkLogger class] methodSignatureForSelector:networkLogSEL]];
        [inv setSelector:networkLogSEL];
        [inv setTarget:[IBGNetworkLogger class]];

        [inv setArgument:&(url) atIndex:2];
        [inv setArgument:&(method) atIndex:3];
        [inv setArgument:&(requestBody) atIndex:4];
        [inv setArgument:&(requestBodySize) atIndex:5];
        [inv setArgument:&(responseBody) atIndex:6];
        [inv setArgument:&(responseBodySize) atIndex:7];
        [inv setArgument:&(responseCode) atIndex:8];
        [inv setArgument:&(requestHeaders) atIndex:9];
        [inv setArgument:&(responseHeaders) atIndex:10];
        [inv setArgument:&(contentType) atIndex:11];
        [inv setArgument:&(errorDomain) atIndex:12];
        [inv setArgument:&(errorCode) atIndex:13];
        [inv setArgument:&(startTime) atIndex:14];
        [inv setArgument:&(duration) atIndex:15];
        [inv setArgument:&(gqlQueryName) atIndex:16];
        [inv setArgument:&(serverErrorMessage) atIndex:17];

        [inv invoke];
    }
}

- (void)willRedirectToStoreWithError:(FlutterError * _Nullable __autoreleasing *)error {
    [Instabug willRedirectToAppStore];
}

@end
