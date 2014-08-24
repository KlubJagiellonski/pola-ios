#import "BPAPIAccessor.h"


@interface BPAPIAccessor ()

@property(nonatomic, readonly) NSURLSession *session;

@end


@implementation BPAPIAccessor

- (id)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{
                @"Content-Type" : @"application/json",
                @"X-Parse-Application-Id" : @"CropLyorPeeuJWwGTFobgwgx3peXJGhZQ8XIdNAP",
                @"X-Parse-REST-API-Key" : @"k14ZVHMT52umlpIdJn9TysO5Zq7N742NRPrEEvCM"
        };
        _session = [NSURLSession sessionWithConfiguration:configuration];
    }

    return self;
}

- (void)performRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *, NSURLResponse *, NSError *))completionHandler {
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request completionHandler:completionHandler];
    [task resume];
}

@end