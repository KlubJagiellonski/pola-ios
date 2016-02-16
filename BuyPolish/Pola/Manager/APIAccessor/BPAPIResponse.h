#import <Foundation/Foundation.h>


@class AFHTTPRequestOperation;


@interface BPAPIResponse : NSObject

@property(nonatomic, readonly) id responseObject;
@property(nonatomic, readonly) NSDictionary *headerFields;
@property(nonatomic, readonly, copy) NSString *responseString;
@property(nonatomic, readonly) NSUInteger length;
@property(nonatomic, readonly) NSInteger statusCode;

+ (instancetype)responseWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject;
+ (instancetype)emptyResponse;

- (instancetype)initWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject;
- (BOOL)isSuccess;

@end