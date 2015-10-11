#import <Foundation/Foundation.h>
#import "BPProductResult.h"

@interface BPProductResult (Utilities)

- (void)parse:(NSDictionary *)dictionary;
- (void)fillMadeInPolandFromBarcode:(NSString *)barcode;
- (BOOL)containsMainInfo;

@end