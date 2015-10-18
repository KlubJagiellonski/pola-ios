#import <Foundation/Foundation.h>


@class BPAPIResponse;


@interface BPAPIAccessor : NSObject

- (BPAPIResponse *)get:(NSString *)apiFunction error:(NSError **)error;
- (BPAPIResponse *)get:(NSString *)apiFunction parameters:(NSDictionary *)parameters error:(NSError **)error;
- (BPAPIResponse *)post:(NSString *)apiFunction json:(NSDictionary *)parameters error:(NSError **)error;
- (BPAPIResponse *)post:(NSString *)apiFunction body:(NSData *)body error:(NSError **)error;

@end