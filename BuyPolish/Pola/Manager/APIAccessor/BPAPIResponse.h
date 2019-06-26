#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation;

@interface BPAPIResponse : NSObject

@property(nonatomic, readonly) id responseObject;
@property(copy, nonatomic, readonly) NSDictionary *headerFields;
@property(copy, nonatomic, readonly) NSString *responseString;
@property(nonatomic, readonly) NSUInteger length;
@property(nonatomic, readonly) NSInteger statusCode;

+ (instancetype)responseWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject;
+ (instancetype)emptyResponse;

- (instancetype)initWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject;
- (BOOL)isSuccess;

@end
