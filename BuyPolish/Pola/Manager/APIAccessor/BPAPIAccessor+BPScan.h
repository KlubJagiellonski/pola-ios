#import "BPAPIAccessor.h"
#import <Foundation/Foundation.h>

@interface BPAPIAccessor (BPScan)

- (NSDictionary *)retrieveProductWithBarcode:(NSString *)barcode error:(NSError **)error;

@end