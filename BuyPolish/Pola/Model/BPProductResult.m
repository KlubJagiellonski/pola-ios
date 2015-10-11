#import "BPProductResult.h"


@implementation BPProductResult

- (instancetype)initWithBarcode:(NSString *)barcode {
    self = [super init];
    if (self) {
        _barcode = barcode;
    }
    return self;
}
@end