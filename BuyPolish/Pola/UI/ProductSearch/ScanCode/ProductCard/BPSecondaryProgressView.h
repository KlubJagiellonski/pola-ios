@import UIKit;

@interface BPSecondaryProgressView : UIView

@property (nonatomic) NSNumber *progress;

- (void)setFillColor:(UIColor *)fillColor;

- (void)setPercentColor:(UIColor *)percentColor;
@end
