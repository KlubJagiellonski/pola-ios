#import "BPAPIAccessor+BPScan.h"
#import "BPAPIResponse.h"

@implementation BPAPIAccessor (BPScan)

- (NSDictionary *)retrieveProductWithBarcode:(NSString *)barcode error:(NSError **)error {
    NSDictionary *params = @{ @"code": barcode };
    BPAPIResponse *response = [self get:@"get_by_code" parameters:params error:error];
    NSDictionary *result = response.responseObject;
    return result;
}

@end
