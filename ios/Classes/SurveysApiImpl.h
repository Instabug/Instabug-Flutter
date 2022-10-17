#import <Flutter/Flutter.h>

@interface SurveysApiImpl : NSObject <SurveysApi>

@property (nonatomic, strong) SurveysFlutterApi* flutterApi;

-(SurveysApiImpl*) initWithFlutterApi:(SurveysFlutterApi*)api;

@end
