#import "BPScanResult.h"


@implementation BPScanResult

- (instancetype)initWithCode:(NSString *)code {
    self = [super init];
    if (self) {
        _code = code;
    }
    return self;
}
@end