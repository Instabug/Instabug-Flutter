#import "Generated/SurveysPigeon.h"
#import "Instabug.h"
#import "SurveysApiImpl.h"

@implementation SurveysApiImpl

- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [isEnabled boolValue];
    IBGSurveys.enabled = boolValue;
}

- (void)showSurveyIfAvailableWithError:(FlutterError *_Nullable *_Nonnull)error {
    [IBGSurveys showSurveyIfAvailable];
}

- (void)showSurveySurveyToken:(NSString *)surveyToken error:(FlutterError *_Nullable *_Nonnull)error {
    [IBGSurveys showSurveyWithToken:surveyToken];
}

- (void)setAutoShowingEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [isEnabled boolValue];
    IBGSurveys.autoShowingEnabled = boolValue;
}

- (void)setShouldShowWelcomeScreenShouldShowWelcomeScreen:(NSNumber *)shouldShowWelcomeScreen error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [shouldShowWelcomeScreen boolValue];
    IBGSurveys.shouldShowWelcomeScreen = boolValue;
}

- (void)setAppStoreURLAppStoreURL:(NSString *)appStoreURL error:(FlutterError *_Nullable *_Nonnull)error {
    IBGSurveys.appStoreURL = appStoreURL;
}

@end
