#import <Foundation/Foundation.h>

@interface UIImage (Scaling)
- (UIImage *)scaledToWidth:(float)width;
- (UIImage *)scaledToHeight:(float)height;
- (int)heightInPixels;
- (int)widthInPixels;
@end
