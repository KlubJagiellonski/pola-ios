#import "BPProduct.h"


@implementation BPProduct

- (instancetype)initWithBarcode:(NSString *)barcode {
    self = [super init];
    if (self) {
        _barcode = barcode;
    }
    return self;
}
@end