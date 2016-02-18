#import "BPAboutRow.h"


@implementation BPAboutRow

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action {
    self = [super init];
    if (self) {
        _title = [title copy];
        _action = action;
        _style = BPAboutRowStyleSingle;
    }

    return self;
}

+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action {
    return [[self alloc] initWithTitle:title action:action];
}

@end