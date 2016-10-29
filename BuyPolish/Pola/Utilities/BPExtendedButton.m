#import "BPExtendedButton.h"

@implementation BPExtendedButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect area = CGRectInset(self.bounds, -self.extendedTouchSize, -self.extendedTouchSize);
    return CGRectContainsPoint(area, point);
}

@end
