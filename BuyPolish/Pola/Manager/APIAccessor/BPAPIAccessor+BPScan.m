#import "BPAPIAccessor+BPScan.h"
#import "BPAPIResponse.h"


@implementation BPAPIAccessor (BPScan)

- (NSDictionary *)retrieveProductWithBarcode:(NSString *)barcode error:(NSError **)error {
    BPAPIResponse *response = [self get:[NSString stringWithFormat:@"get_by_code/%@", barcode] error:error];
    NSDictionary *result = response.responseObject;
    return result;
}

@end