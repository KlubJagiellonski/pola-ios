#import "BPAPIAccessor.h"
#import "AFHTTPRequestOperation.h"
#import "BPAPIResponse.h"


NSString *const BPAPIAccessorAPIServerUrl = @"https://api.parse.com";
NSString *const BPAPIAccessorAPIVersion = @"1";


@interface BPAPIAccessor ()

@property(nonatomic, readonly) NSOperationQueue *operationsQueue;

@end


@implementation BPAPIAccessor

- (id)init {
    self = [super init];
    if (self) {
        _operationsQueue = [[NSOperationQueue alloc] init];
        _operationsQueue.maxConcurrentOperationCount = 1;
    }

    return self;
}

- (NSString *)baseUrl {
    return [BPAPIAccessorAPIServerUrl stringByAppendingPathComponent:BPAPIAccessorAPIVersion];
}

- (BPAPIResponse *)get:(NSString *)apiFunction parameters:(NSDictionary *)parameters error:(NSError **)error{
    NSString *url = [[self baseUrl] stringByAppendingPathComponent:apiFunction];
    if(parameters) {
        [url stringByAppendingFormat:@"?%@", [self stringFromParameters:parameters]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request setHTTPMethod:@"GET"];
    return [self performRequest:request error:error];
}

- (BPAPIResponse *)post:(NSString *)apiFunction parameters:(NSDictionary *)parameters error:(NSError **)error{
    NSString *url = [[self baseUrl] stringByAppendingPathComponent:apiFunction];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    if(parameters) {
        NSString *stringParameters = [self stringFromParameters:parameters];
        [request setHTTPBody:[stringParameters dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [request setHTTPMethod:@"POST"];
    return [self performRequest:request error:error];
}

- (BPAPIResponse *)performRequest:(NSURLRequest *)request error:(NSError **)error {
    request = [self configureRequest:request];

    BPLog(@"Sending Request: %@", request);

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [self.operationsQueue addOperation:operation];
    [operation waitUntilFinished];

    id responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:error];
    BPAPIResponse *response = [BPAPIResponse responseWithOperation:operation responseObject:responseObject];

    BPLog(@"Received Response: %@", response);

    [self setError:error onBadResponseInOperation:operation];

    return response;
}

- (NSURLRequest *)configureRequest:(NSURLRequest *)request {
    NSMutableURLRequest *newUrlRequest = [request mutableCopy];
    [newUrlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [newUrlRequest setValue:@"CropLyorPeeuJWwGTFobgwgx3peXJGhZQ8XIdNAP" forHTTPHeaderField:@"X-Parse-Application-Id"];
    [newUrlRequest setValue:@"3pwkiOpjTE4JmqfgvR188wrMIlztbFooFmtNSawe" forHTTPHeaderField:@"X-Parse-REST-API-Key"];
    return newUrlRequest;
}

#pragma mark - Helpers

- (NSString *)stringFromParameters:(NSDictionary *)parameters {
    NSMutableString *getParameters = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSString *value, BOOL *stop) {
        [getParameters appendFormat:@"%@=%@&", name, value];
    }];
    [getParameters substringWithRange:NSMakeRange(0, getParameters.length - 1)];
    return getParameters;
}

- (void)setError:(NSError **)error onBadResponseInOperation:(AFHTTPRequestOperation *)operation {
    if ((operation.error != nil || !operation.responseData) && error != NULL) {
        *error = operation.error;
    }
}

@end