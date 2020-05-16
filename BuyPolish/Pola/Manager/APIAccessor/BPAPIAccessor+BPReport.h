#import "BPAPIAccessor.h"
#import <Foundation/Foundation.h>

@interface BPAPIAccessor (BPReport)

- (NSDictionary *)addReportWithDescription:(NSString *)description
                                 productId:(NSNumber *)productId
                                filesCount:(NSUInteger)filesCount
                                     error:(NSError **)error;

- (NSDictionary *)addImageAtPath:(NSString *)imageAtPath forUrl:(NSString *)requestUrl error:(NSError **)error;

@end