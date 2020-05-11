#import "UIApplication+BPStatusBarHeight.h"
#import "UIView+SafeAreaInsets.h"

@implementation UIView (SafeAreaInsets)

- (CGFloat)topSafeAreaInset {
    if (@available(iOS 11, *)) {
        return self.safeAreaInsets.top;
    } else {
        return [UIApplication statusBarHeight];
    }
}

@end
