#import <Foundation/Foundation.h>
#import "Generated/InstabugPigeon.h"
#import "Instabug.h"
#import "InstabugApiImpl.h"
#import "InstabugFlutterPlugin.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)((rgbValue & 0xFF000000) >> 24))/255.0];

@implementation InstabugApiImpl

- (void)startToken:(NSString *)token invocationEvents:(NSArray<NSString *> *)invocationEvents error:(FlutterError *_Nullable *_Nonnull)error {
    SEL setPrivateApiSEL = NSSelectorFromString(@"setCurrentPlatform:");
    if ([[Instabug class] respondsToSelector:setPrivateApiSEL]) {
        NSInteger *platformID = IBGPlatformFlutter;
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[Instabug class] methodSignatureForSelector:setPrivateApiSEL]];
        [inv setSelector:setPrivateApiSEL];
        [inv setTarget:[Instabug class]];
        [inv setArgument:&(platformID) atIndex:2];
        [inv invoke];
    }

    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger events = 0;
    for (NSString * invocationEvent in invocationEvents) {
        events |= ((NSNumber *) constants[invocationEvent]).integerValue;
    }
    if (events == 0) {
        events = IBGInvocationEventNone;
    }

    [Instabug startWithToken:token invocationEvents:events];
}

- (void)showWithError:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug show];
}

- (void)showWelcomeMessageWithModeMode:(NSString *)mode error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger welcomeMode = ((NSNumber *) constants[mode]).integerValue;
    [Instabug showWelcomeMessageWithMode:welcomeMode];
}

- (void)identifyUserEmail:(NSString *)email name:(nullable NSString *)name error:(FlutterError *_Nullable *_Nonnull)error {
    if ([name isKindOfClass:[NSNull class]]) {
      [Instabug identifyUserWithEmail:email name:nil];
    } else {
      [Instabug identifyUserWithEmail:email name:name];
    }
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
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger localeInt = ((NSNumber *) constants[locale]).integerValue;
    [Instabug setLocale:localeInt];
}

- (void)setColorThemeTheme:(NSString *)theme error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger intColorTheme = ((NSNumber *) constants[theme]).integerValue;
    [Instabug setColorTheme:intColorTheme];
}

- (void)setWelcomeMessageModeMode:(NSString *)mode error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger welcomeMode = ((NSNumber *) constants[mode]).integerValue;
    [Instabug setWelcomeMessageMode:welcomeMode];
}

- (void)setPrimaryColorColor:(NSNumber *)color error:(FlutterError *_Nullable *_Nonnull)error {
    Instabug.tintColor = UIColorFromRGB([color longValue]);
}

- (void)setSessionProfilerEnabledEnabled:(NSNumber *)enabled error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [enabled boolValue];
    [Instabug setSessionProfilerEnabled:boolValue];
}

- (void)setValueForStringWithKeyValue:(NSString *)value key:(NSString *)key error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    [Instabug setValue:value forStringWithKey:constants[key]];
}

- (void)appendTagsTags:(NSArray<NSString *> *)tags error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug appendTags:tags];
}

- (void)resetTagsWithError:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug resetTags];
}

- (nullable NSArray<NSString *> *)getTagsWithError:(FlutterError *_Nullable *_Nonnull)error {
    return [Instabug getTags];
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

- (nullable NSString *)getUserAttributeForKeyKey:(NSString *)key error:(FlutterError *_Nullable *_Nonnull)error {
    return [Instabug userAttributeForKey:key];
}

- (nullable NSDictionary<NSString *, NSString *> *)getUserAttributesWithError:(FlutterError *_Nullable *_Nonnull)error {
    return Instabug.userAttributes;
}

- (void)setDebugEnabledEnabled:(NSNumber *)enabled error:(FlutterError *_Nullable *_Nonnull)error {
    // Android Only
}

- (void)setSdkDebugLogsLevelLevel:(NSString *)level error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger sdkDebugLogsLevelInt = ((NSNumber *) constants[level]).integerValue;
    [Instabug setSdkDebugLogsLevel:sdkDebugLogsLevelInt];
}

- (void)setReproStepsModeMode:(NSString *)mode error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger reproMode = ((NSNumber *) constants[mode]).integerValue;
    [Instabug setReproStepsMode:reproMode];
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

- (void)addFileAttachmentWithURLFilePath:(NSString *)filePath fileName:(NSString *)fileName error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug addFileAttachmentWithURL:[NSURL URLWithString:filePath]];
}

- (void)addFileAttachmentWithDataData:(FlutterStandardTypedData *)data fileName:(NSString *)fileName error:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug addFileAttachmentWithData:[data data]];
}

- (void)clearFileAttachmentsWithError:(FlutterError *_Nullable *_Nonnull)error {
    [Instabug clearFileAttachments];
}

- (void)enableAndroidWithError:(FlutterError *_Nullable *_Nonnull)error {
    // Android Only
}

- (void)disableAndroidWithError:(FlutterError *_Nullable *_Nonnull)error {
    // Android Only
}

@end
