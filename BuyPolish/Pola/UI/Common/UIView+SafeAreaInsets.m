#import "UIView+SafeAreaInsets.h"
#import "UIApplication+BPStatusBarHeight.h"

@implementation UIView (SafeAreaInsets)

- (CGFloat)topSafeAreaInset {
    if (@available(iOS 11, *)) {
        return self.safeAreaInsets.top;
    } else {
        return [UIApplication statusBarHeight];
    }
}

@end
