#import <Foundation/Foundation.h>


@class BPAPIResponse;


@interface BPAPIAccessor : NSObject

- (BPAPIResponse *)get:(NSString *)apiFunction parameters:(NSDictionary *)parameters error:(NSError **)error;
- (BPAPIResponse *)post:(NSString *)apiFunction parameters:(NSDictionary *)parameters error:(NSError **)error;

@end