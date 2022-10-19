#import "Instabug.h"
#import "InstabugLogApi.h"

@implementation InstabugLogApi

- (void)logVerboseMessage:(NSString *)message error:(FlutterError *_Nullable *_Nonnull)error {
    [IBGLog logVerbose:message];
}

- (void)logDebugMessage:(NSString *)message error:(FlutterError *_Nullable *_Nonnull)error {
    [IBGLog logDebug:message];
}

- (void)logInfoMessage:(NSString *)message error:(FlutterError *_Nullable *_Nonnull)error {
    [IBGLog logInfo:message];
}

- (void)logWarnMessage:(NSString *)message error:(FlutterError *_Nullable *_Nonnull)error {
    [IBGLog logWarn:message];
}

- (void)logErrorMessage:(NSString *)message error:(FlutterError *_Nullable *_Nonnull)error {
    [IBGLog logError:message];
}

- (void)clearAllLogsWithError:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [IBGLog clearAllLogs];
}

@end
