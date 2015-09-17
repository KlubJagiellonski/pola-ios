#import "BPUtilities.h"


@implementation BPUtilities

+ (id)handleNull:(id)object {
    if([object isKindOfClass:[NSNull class]]) {
        return nil;
    }
    return object;
}

@end