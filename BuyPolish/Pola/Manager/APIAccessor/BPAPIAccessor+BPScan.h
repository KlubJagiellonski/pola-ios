#import <Foundation/Foundation.h>
#import "BPAPIAccessor.h"

@interface BPAPIAccessor (BPScan)

- (NSDictionary *)retrieveProductWithBarcode:(NSString *)barcode error:(NSError **)error;

@end