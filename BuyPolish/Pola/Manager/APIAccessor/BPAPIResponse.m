#import "BPAPIResponse.h"
#import "AFHTTPRequestOperation.h"

@implementation BPAPIResponse

- (instancetype)initWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject {
    self = [super init];
    if (self) {
        _responseObject = responseObject;
        _headerFields = operation.response.allHeaderFields;
        _responseString = operation.responseString;
        _length = operation.responseData.length;
        _statusCode = operation.response.statusCode;
    }

    return self;
}

+ (instancetype)responseWithOperation:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject {
    return [[self alloc] initWithOperation:operation responseObject:responseObject];
}

+ (instancetype)emptyResponse {
    return [[self alloc] initWithOperation:nil responseObject:nil];
}

- (BOOL)isSuccess {
    return self.statusCode == 200;
}

- (NSString *)description {
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"responseObject: %@", _responseObject];
    [description appendFormat:@", statusCode: %li", (long)self.statusCode];
    [description appendString:@">"];
    return description;
}

@end
