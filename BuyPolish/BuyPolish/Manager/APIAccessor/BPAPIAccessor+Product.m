#import "BPAPIAccessor+Product.h"
#import "BPProduct.h"
#import "NSDictionary+BPJSON.h"
#import "BPAPIResponse.h"


@implementation BPAPIAccessor (Product)

- (NSDictionary *)retrieveProductWithBarcode:(NSString *)barcode error:(NSError **)error {
    NSDictionary *where = @{
        @"barcode" : barcode
    };
    
    NSDictionary *parameters = @{
        @"where" : [where jsonString]
    };

    NSArray *products = [self getClass:@"Product" parameters:parameters error:error];
    NSDictionary *productDictionary = nil;
    if(products.count > 0) {
        productDictionary = products.firstObject;
    }
    return productDictionary;
}

- (NSArray *)getClass:(NSString *)className parameters:(NSDictionary *)parameters error:(NSError **)error {
    NSString *methodName = [@"classes" stringByAppendingPathComponent:className];
    BPAPIResponse *response = [self get:methodName parameters:parameters error:error];

    NSDictionary *responseDictionary = response.responseObject;
    NSArray *results = responseDictionary[@"results"];
    return results;
}

@end