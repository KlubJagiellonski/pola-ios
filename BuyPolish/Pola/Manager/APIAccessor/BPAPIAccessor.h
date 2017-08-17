#import <Foundation/Foundation.h>


@class BPAPIResponse;


@interface BPAPIAccessor : NSObject

- (BPAPIResponse *)get:(NSString *)apiFunction error:(NSError **)error;
- (BPAPIResponse *)get:(NSString *)apiFunction parameters:(NSDictionary *)parameters error:(NSError **)error;
- (BPAPIResponse *)post:(NSString *)apiFunction jsonBody:(NSDictionary *)jsonBody error:(NSError **)error;

- (BPAPIResponse *)post:(NSString *)apiFunction body:(NSData *)body parameters:(NSDictionary *)parameters error:(NSError **)error;

- (BPAPIResponse *)putAmazonMultipart:(NSString *)url data:(NSData *)data mimeType:(NSString *)mimeType error:(NSError **)error;

@end
