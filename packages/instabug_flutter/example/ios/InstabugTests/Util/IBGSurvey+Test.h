// This header file makes IBGSurvey title property editable to be used in tests.

#import <InstabugSDK/IBGSurveys.h>

@interface IBGSurvey (Test)
@property (nonatomic, strong) NSString *title;
@end
