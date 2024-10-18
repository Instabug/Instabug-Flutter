#import <Foundation/Foundation.h>
#import <Instabug/Instabug.h>

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

+ (ArgsDictionary *)locales;
+ (NSDictionary<NSString *, NSString *> *)placeholders;

@end
