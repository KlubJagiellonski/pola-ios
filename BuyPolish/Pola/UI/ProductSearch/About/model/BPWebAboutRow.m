#import "BPWebAboutRow.h"

@implementation BPWebAboutRow

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url analyticsName:(NSString *)analyticsName {
    self = [super initWithTitle:title action:action];
    if (self) {
        self.url = url;
    }
    return self;
}

+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url analyticsName:(NSString *)analyticsName {
    return [[self alloc] initWithTitle:title action:action url:url analyticsName:analyticsName];
}

@end