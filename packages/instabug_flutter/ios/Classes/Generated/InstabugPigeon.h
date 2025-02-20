// Autogenerated from Pigeon (v10.1.5), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN


/// The codec used by FeatureFlagsFlutterApi.
NSObject<FlutterMessageCodec> *FeatureFlagsFlutterApiGetCodec(void);

@interface FeatureFlagsFlutterApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onW3CFeatureFlagChangeIsW3cExternalTraceIDEnabled:(NSNumber *)isW3cExternalTraceIDEnabled isW3cExternalGeneratedHeaderEnabled:(NSNumber *)isW3cExternalGeneratedHeaderEnabled isW3cCaughtHeaderEnabled:(NSNumber *)isW3cCaughtHeaderEnabled completion:(void (^)(FlutterError *_Nullable))completion;
@end

/// The codec used by InstabugHostApi.
NSObject<FlutterMessageCodec> *InstabugHostApiGetCodec(void);

@protocol InstabugHostApi
- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isEnabledWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSNumber *)isBuiltWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)initToken:(NSString *)token invocationEvents:(NSArray<NSString *> *)invocationEvents debugLogsLevel:(NSString *)debugLogsLevel error:(FlutterError *_Nullable *_Nonnull)error;
- (void)showWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)showWelcomeMessageWithModeMode:(NSString *)mode error:(FlutterError *_Nullable *_Nonnull)error;
- (void)identifyUserEmail:(NSString *)email name:(nullable NSString *)name userId:(nullable NSString *)userId error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setUserDataData:(NSString *)data error:(FlutterError *_Nullable *_Nonnull)error;
- (void)logUserEventName:(NSString *)name error:(FlutterError *_Nullable *_Nonnull)error;
- (void)logOutWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)setLocaleLocale:(NSString *)locale error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setColorThemeTheme:(NSString *)theme error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setWelcomeMessageModeMode:(NSString *)mode error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setPrimaryColorColor:(NSNumber *)color error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setSessionProfilerEnabledEnabled:(NSNumber *)enabled error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setValueForStringWithKeyValue:(NSString *)value key:(NSString *)key error:(FlutterError *_Nullable *_Nonnull)error;
- (void)appendTagsTags:(NSArray<NSString *> *)tags error:(FlutterError *_Nullable *_Nonnull)error;
- (void)resetTagsWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)getTagsWithCompletion:(void (^)(NSArray<NSString *> *_Nullable, FlutterError *_Nullable))completion;
- (void)addExperimentsExperiments:(NSArray<NSString *> *)experiments error:(FlutterError *_Nullable *_Nonnull)error;
- (void)removeExperimentsExperiments:(NSArray<NSString *> *)experiments error:(FlutterError *_Nullable *_Nonnull)error;
- (void)clearAllExperimentsWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)addFeatureFlagsFeatureFlagsMap:(NSDictionary<NSString *, NSString *> *)featureFlagsMap error:(FlutterError *_Nullable *_Nonnull)error;
- (void)removeFeatureFlagsFeatureFlags:(NSArray<NSString *> *)featureFlags error:(FlutterError *_Nullable *_Nonnull)error;
- (void)removeAllFeatureFlagsWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)setUserAttributeValue:(NSString *)value key:(NSString *)key error:(FlutterError *_Nullable *_Nonnull)error;
- (void)removeUserAttributeKey:(NSString *)key error:(FlutterError *_Nullable *_Nonnull)error;
- (void)getUserAttributeForKeyKey:(NSString *)key completion:(void (^)(NSString *_Nullable, FlutterError *_Nullable))completion;
- (void)getUserAttributesWithCompletion:(void (^)(NSDictionary<NSString *, NSString *> *_Nullable, FlutterError *_Nullable))completion;
- (void)setReproStepsConfigBugMode:(nullable NSString *)bugMode crashMode:(nullable NSString *)crashMode sessionReplayMode:(nullable NSString *)sessionReplayMode error:(FlutterError *_Nullable *_Nonnull)error;
- (void)reportScreenChangeScreenName:(NSString *)screenName error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setCustomBrandingImageLight:(NSString *)light dark:(NSString *)dark error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setFontFont:(NSString *)font error:(FlutterError *_Nullable *_Nonnull)error;
- (void)addFileAttachmentWithURLFilePath:(NSString *)filePath fileName:(NSString *)fileName error:(FlutterError *_Nullable *_Nonnull)error;
- (void)addFileAttachmentWithDataData:(FlutterStandardTypedData *)data fileName:(NSString *)fileName error:(FlutterError *_Nullable *_Nonnull)error;
- (void)clearFileAttachmentsWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)networkLogData:(NSDictionary<NSString *, id> *)data error:(FlutterError *_Nullable *_Nonnull)error;
- (void)registerFeatureFlagChangeListenerWithError:(FlutterError *_Nullable *_Nonnull)error;
/// @return `nil` only when `error != nil`.
- (nullable NSDictionary<NSString *, NSNumber *> *)isW3CFeatureFlagsEnabledWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)willRedirectToStoreWithError:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void InstabugHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<InstabugHostApi> *_Nullable api);

NS_ASSUME_NONNULL_END
