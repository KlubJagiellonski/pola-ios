#import "BPWebAboutRow.h"


@implementation BPWebAboutRow {

}
- (instancetype)initWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url analyticsName:(NSString *)analyticsName {
    self = [super init];
    if (self) {
        self.title = title;
        self.action = action;
        self.url = url;
        self.analyticsName = analyticsName;
    }
    return self;
}

+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url analyticsName:(NSString *)analyticsName {
    return [[self alloc] initWithTitle:title action:action url:url analyticsName:analyticsName];
}

@end