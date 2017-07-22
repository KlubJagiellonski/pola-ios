#import <Objection/Objection.h>
#import "BPAPIAccessor.h"
#import "AFHTTPRequestOperation.h"
#import "BPAPIResponse.h"
#import "NSDictionary+BPJSON.h"
#import "BPDeviceHelper.h"

//NSString *const BPAPIAccessorAPIServerUrl = @"https://www.pola-app.pl/a";
//NSString *const BPAPIAccessorAPIServerUrl = @"https://www.pola-app.pl/a/v2";
NSString *const BPAPIAccessorAPIServerUrl = @"https://www.pola-app.pl/a/v3";
//NSString *const BPAPIAccessorAPIServerUrl = @"https://pola-staging.herokuapp.com/a/v2";
//NSString *const BPAPIAccessorAPIServerUrl = @"http://localhost:8888";
NSString *const BPAPIAccessorAPIDeviceId = @"device_id";


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
    return BPAPIAccessorAPIServerUrl;
}

- (BPAPIResponse *)get:(NSString *)apiFunction error:(NSError **)error {
    return [self get:apiFunction parameters:nil error:error];
}

- (BPAPIResponse *)get:(NSString *)apiFunction parameters:(NSDictionary *)parameters error:(NSError **)error {
    NSString *url = [[self baseUrl] stringByAppendingPathComponent:apiFunction];
    parameters = [self addDefaultParameters:parameters];
    if (parameters) {
        url = [url stringByAppendingFormat:@"?%@", [self stringFromParameters:parameters]];
    }
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request setHTTPMethod:@"GET"];
    return [self performRequest:request error:error];
}

- (NSDictionary *)addDefaultParameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    mutableParameters[BPAPIAccessorAPIDeviceId] = [BPDeviceHelper deviceId];
    return mutableParameters;
}

- (BPAPIResponse *)post:(NSString *)apiFunction jsonBody:(NSDictionary *)jsonBody error:(NSError **)error {
    NSData *body;
    if (jsonBody) {
        body = [[jsonBody jsonString] dataUsingEncoding:NSUTF8StringEncoding];
    }
    return [self post:apiFunction body:body parameters:nil error:error];
}

- (BPAPIResponse *)post:(NSString *)apiFunction body:(NSData *)body parameters:(NSDictionary *)parameters error:(NSError **)error {
    NSString *url = [[self baseUrl] stringByAppendingPathComponent:apiFunction];
    parameters = [self addDefaultParameters:parameters];
    url = [url stringByAppendingFormat:@"?%@", [self stringFromParameters:parameters]];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request setHTTPBody:body];
    [request setHTTPMethod:@"POST"];
    return [self performRequest:request error:error];
}

- (BPAPIResponse *)putAmazonMultipart:(NSString *)url data:(NSData *)data mimeType:(NSString *)mimeType error:(NSError **)error {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:url]];
    [request addValue:@"public-read" forHTTPHeaderField:@"x-amz-acl"];
    [request addValue:mimeType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    [request setHTTPBody:[NSData dataWithData:data]];

    return [self performRequest:request defaultConfiguration:NO error:error];
}

- (BPAPIResponse *)performRequest:(NSURLRequest *)request error:(NSError **)error {
    return [self performRequest:request defaultConfiguration:YES error:error];
}

- (BPAPIResponse *)performRequest:(NSURLRequest *)request defaultConfiguration:(BOOL)defaultConfiguration error:(NSError **)error {
    if(defaultConfiguration) {
        request = [self configureRequest:request];
    }

    BPLog(@"Sending Request: %@", request);

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [self.operationsQueue addOperation:operation];
    [operation waitUntilFinished];

    id responseObject = nil;
    if (operation.responseData != nil && operation.responseData.length > 0) {
        responseObject = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:error];
    }
    BPAPIResponse *response = [BPAPIResponse responseWithOperation:operation responseObject:responseObject];

    BPLog(@"Received Response: %@", response);

    [self setError:error onBadResponseInOperation:operation];
    [self setError:error onBadResponse:response];

    return response;
}

- (NSURLRequest *)configureRequest:(NSURLRequest *)request {
    NSMutableURLRequest *newUrlRequest = [request mutableCopy];
    [newUrlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return newUrlRequest;
}

#pragma mark - Helpers

- (NSString *)stringFromParameters:(NSDictionary *)parameters {
    NSMutableString *getParameters = [NSMutableString string];
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSString *value, BOOL *stop) {
        [getParameters appendFormat:@"%@=%@&", name, value];
    }];
    return [getParameters substringWithRange:NSMakeRange(0, getParameters.length - 1)];
}

- (void)setError:(NSError **)error onBadResponseInOperation:(AFHTTPRequestOperation *)operation {
    if ((operation.error != nil || !operation.responseData) && error != NULL) {
        *error = operation.error;
    }
}

- (void)setError:(NSError **)error onBadResponse:(BPAPIResponse *)response {
    if (![response isSuccess]) {
        *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:response.statusCode userInfo:@{NSLocalizedDescriptionKey : [response description]}];
    }
}

@end
