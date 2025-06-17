#import <Flutter/Flutter.h>
#import "InstabugSDK.h"
#import "SurveysApi.h"

extern void InitSurveysApi(id<FlutterBinaryMessenger> messenger) {
    SurveysFlutterApi *flutterApi = [[SurveysFlutterApi alloc] initWithBinaryMessenger:messenger];
    SurveysApi *api = [[SurveysApi alloc] initWithFlutterApi:flutterApi];
    SurveysHostApiSetup(messenger, api);
}

@implementation SurveysApi

- (instancetype)initWithFlutterApi:(SurveysFlutterApi *)api {
    self = [super init];
    self.flutterApi = api;
    return self;
}

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

- (void)hasRespondedToSurveySurveyToken:(NSString *)surveyToken completion:(void (^)(NSNumber *_Nullable, FlutterError *_Nullable))completion {
    [IBGSurveys hasRespondedToSurveyWithToken:surveyToken
                            completionHandler:^(BOOL hasResponded) {
                              NSNumber *boolNumber = [NSNumber numberWithBool:hasResponded];
                              completion(boolNumber, nil);
                            }];
}

- (void)getAvailableSurveysWithCompletion:(void (^)(NSArray<NSString *> *_Nullable, FlutterError *_Nullable))completion {
    [IBGSurveys availableSurveysWithCompletionHandler:^(NSArray<IBGSurvey *> *availableSurveys) {
      NSMutableArray<NSString *> *titles = [[NSMutableArray alloc] init];

      for (IBGSurvey *survey in availableSurveys) {
          [titles addObject:[survey title]];
      }

      completion(titles, nil);
    }];
}

- (void)bindOnShowSurveyCallbackWithError:(FlutterError *_Nullable *_Nonnull)error {
    IBGSurveys.willShowSurveyHandler = ^{
      [self->_flutterApi onShowSurveyWithCompletion:^(FlutterError *_Nullable _){
      }];
    };
}

- (void)bindOnDismissSurveyCallbackWithError:(FlutterError *_Nullable *_Nonnull)error {
    IBGSurveys.didDismissSurveyHandler = ^{
      [self->_flutterApi onDismissSurveyWithCompletion:^(FlutterError *_Nullable _){
      }];
    };
}

@end
