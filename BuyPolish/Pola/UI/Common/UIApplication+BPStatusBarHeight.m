#import "UIApplication+BPStatusBarHeight.h"


@implementation UIApplication (BPStatusBarHeight)

+ (CGFloat)statusBarHeight {
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    return fminf(statusBarFrame.size.width, statusBarFrame.size.height);
}

@end