#import "SurveysPigeon.h"

@interface SurveysApi : NSObject<SurveysHostApi>

@property (nonatomic, strong) SurveysFlutterApi* flutterApi;

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)messenger;

@end
