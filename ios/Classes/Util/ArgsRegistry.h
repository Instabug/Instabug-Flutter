#import <Foundation/Foundation.h>
#import <Instabug/IBGTypes.h>

typedef NSDictionary<NSString *, NSNumber *> ArgsDictionary;

@interface ArgsRegistry : NSObject

+ (ArgsDictionary *)sdkLogLevels;
+ (ArgsDictionary *)logLevels __deprecated_msg("Use sdkLogLevels instead.");
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
+ (ArgsDictionary *)reproStates;
+ (ArgsDictionary *)locales;
+ (NSDictionary<NSString *, NSString *> *)placeholders;

@end
