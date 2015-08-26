#import <Foundation/Foundation.h>
#import "BPProduct.h"

@interface BPProduct (Utilities)

- (void)parse:(NSDictionary *)dictionary;
- (void)fillMadeInPolandFromBarcode:(NSString *)barcode;
- (BOOL)containsMainInfo;

@end