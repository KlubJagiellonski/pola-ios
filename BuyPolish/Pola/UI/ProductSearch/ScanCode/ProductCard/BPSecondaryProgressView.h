#import <Foundation/Foundation.h>

@interface BPSecondaryProgressView : UIView

- (void)setProgress:(NSNumber *)progress;

- (void)setFillColor:(UIColor *)fillColor;

- (void)setPercentColor:(UIColor *)percentColor;
@end
