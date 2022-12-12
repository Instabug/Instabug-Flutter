// This header file defines IBGNetworkLogger methods that are called using selectors for test verification.

#import <Instabug/Instabug.h>

@interface IBGNetworkLogger (Test)
+ (void)addNetworkLogWithUrl:(NSString *)url
                      method:(NSString *)method
                 requestBody:(NSString *)request
             requestBodySize:(int64_t)requestBodySize
                responseBody:(NSString *)response
            responseBodySize:(int64_t)responseBodySize
                responseCode:(int32_t)code
              requestHeaders:(NSDictionary *)requestHeaders
             responseHeaders:(NSDictionary *)responseHeaders
                 contentType:(NSString *)contentType
                 errorDomain:(NSString *)errorDomain
                   errorCode:(int32_t)errorCode
                   startTime:(int64_t)startTime
                    duration:(int64_t) duration
                gqlQueryName:(NSString *_Nullable)gqlQueryName
          serverErrorMessage:(NSString *_Nullable)gqlServerError;
@end
