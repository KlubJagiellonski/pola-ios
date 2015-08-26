#import <Foundation/Foundation.h>


#define BPLog(nsstring_format, ...)    \
    do {                        \
        [BPLogger logWithLine:__LINE__ fileName:[NSString stringWithUTF8String:__FILE__] \
        method:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
        format:nsstring_format, \
        ##__VA_ARGS__];\
} while(0)


@interface BPLogger : NSObject

+ (void)logWithLine:(NSInteger)line fileName:(NSString *)fileName method:(NSString *)method format:(NSString *)format, ...;

@end