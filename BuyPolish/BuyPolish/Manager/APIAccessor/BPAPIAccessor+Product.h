#import <Foundation/Foundation.h>
#import "BPAPIAccessor.h"

@interface BPAPIAccessor (Product)


- (NSDictionary *)retrieveProductWithBarcode:(NSString *)barcode error:(NSError **)error;
@end