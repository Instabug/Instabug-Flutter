#import "SurveysPigeon.h"

extern void InitSurveysApi(id<FlutterBinaryMessenger> messenger);

@interface SurveysApi : NSObject <SurveysHostApi>

@property(nonatomic, strong) SurveysFlutterApi *flutterApi;
- (instancetype)initWithFlutterApi:(SurveysFlutterApi *)api;

@end
