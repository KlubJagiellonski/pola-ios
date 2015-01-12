#import "BPAPIAccessor+Product.h"
#import "BPAPIResponse.h"


@implementation BPAPIAccessor (Product)

- (NSDictionary *)retrieveProductWithBarcode:(NSString *)barcode error:(NSError **)error {
    BPAPIResponse *response = [self get:[NSString stringWithFormat:@"product/%@", barcode] error:error];
    NSDictionary *result = response.responseObject;
    return result[@"result"];
}

- (NSArray *)getClass:(NSString *)className parameters:(NSDictionary *)parameters error:(NSError **)error {
    NSString *methodName = [@"classes" stringByAppendingPathComponent:className];
    BPAPIResponse *response = [self get:methodName parameters:parameters error:error];

    NSDictionary *responseDictionary = response.responseObject;
    NSArray *results = responseDictionary[@"results"];
    return results;
}

@end