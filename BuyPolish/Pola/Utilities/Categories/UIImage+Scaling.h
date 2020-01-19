#import <UIKit/UIKit.h>

@interface UIImage (Scaling)
- (UIImage *)scaledToWidth:(CGFloat)width;
- (UIImage *)scaledToHeight:(CGFloat)height;
- (int)heightInPixels;
- (int)widthInPixels;
@end
