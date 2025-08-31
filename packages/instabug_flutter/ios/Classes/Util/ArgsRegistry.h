#import <Foundation/Foundation.h>
#import <InstabugSDK/InstabugSDK.h>

typedef NSDictionary<NSString *, NSNumber *> ArgsDictionary;

@interface ArgsRegistry : NSObject

+ (ArgsDictionary *)sdkLogLevels;
+ (ArgsDictionary *)invocationEvents;
+ (ArgsDictionary *)invocationOptions;
+ (ArgsDictionary *)colorThemes;
+ (ArgsDictionary *)floatingButtonEdges;
+ (ArgsDictionary *)recordButtonPositions;
+ (ArgsDictionary *)welcomeMessageStates;
+ (ArgsDictionary *)reportTypes;
+ (ArgsDictionary *)dismissTypes;
+ (ArgsDictionary *)actionTypes;
+ (ArgsDictionary *)extendedBugReportStates;
+ (ArgsDictionary *)reproModes;
+ (ArgsDictionary *)nonFatalExceptionLevel;
+ (ArgsDictionary *)autoMasking;

+ (ArgsDictionary *)locales;
+ (ArgsDictionary *)userStepsGesture;

+ (NSDictionary<NSString *, NSString *> *)placeholders;
+ (ArgsDictionary *) userConsentActionTypes;

@end
