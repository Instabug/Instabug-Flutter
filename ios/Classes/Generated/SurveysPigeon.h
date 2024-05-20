// Autogenerated from Pigeon (v10.1.5), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import <Foundation/Foundation.h>

@protocol FlutterBinaryMessenger;
@protocol FlutterMessageCodec;
@class FlutterError;
@class FlutterStandardTypedData;

NS_ASSUME_NONNULL_BEGIN


/// The codec used by SurveysFlutterApi.
NSObject<FlutterMessageCodec> *SurveysFlutterApiGetCodec(void);

@interface SurveysFlutterApi : NSObject
- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)binaryMessenger;
- (void)onShowSurveyWithCompletion:(void (^)(FlutterError *_Nullable))completion;
- (void)onDismissSurveyWithCompletion:(void (^)(FlutterError *_Nullable))completion;
@end

/// The codec used by SurveysHostApi.
NSObject<FlutterMessageCodec> *SurveysHostApiGetCodec(void);

@protocol SurveysHostApi
- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error;
- (void)showSurveyIfAvailableWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)showSurveySurveyToken:(NSString *)surveyToken error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setAutoShowingEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setShouldShowWelcomeScreenShouldShowWelcomeScreen:(NSNumber *)shouldShowWelcomeScreen error:(FlutterError *_Nullable *_Nonnull)error;
- (void)setAppStoreURLAppStoreURL:(NSString *)appStoreURL error:(FlutterError *_Nullable *_Nonnull)error;
- (void)hasRespondedToSurveySurveyToken:(NSString *)surveyToken completion:(void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion;
- (void)getAvailableSurveysWithCompletion:(void (^)(NSArray<NSString *> *_Nullable, FlutterError *_Nullable))completion;
- (void)bindOnShowSurveyCallbackWithError:(FlutterError *_Nullable *_Nonnull)error;
- (void)bindOnDismissSurveyCallbackWithError:(FlutterError *_Nullable *_Nonnull)error;
@end

extern void SurveysHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<SurveysHostApi> *_Nullable api);

NS_ASSUME_NONNULL_END
