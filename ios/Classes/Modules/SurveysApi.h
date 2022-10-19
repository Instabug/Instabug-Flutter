#import "SurveysPigeon.h"

@interface SurveysApi : NSObject <SurveysHostApi>

@property (nonatomic, strong) SurveysFlutterApi* flutterApi;

-(SurveysApi*) initWithFlutterApi:(SurveysFlutterApi*)api;

@end
