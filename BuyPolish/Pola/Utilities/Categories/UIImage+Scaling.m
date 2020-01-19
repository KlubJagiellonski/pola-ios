#import "UIImage+Scaling.h"

@implementation UIImage (Scaling)

- (UIImage *)scaledToWidth:(CGFloat)width {
    CGFloat oldWidth = self.size.width;
    CGFloat scaleFactor = width / oldWidth;

    CGFloat newHeight = self.size.height * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaledToHeight:(CGFloat)height {
    CGFloat oldHeight = self.size.height;
    CGFloat scaleFactor = height / oldHeight;

    CGFloat newWidth = self.size.width * scaleFactor;
    CGFloat newHeight = oldHeight * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (int)heightInPixels {
    return self.size.height * self.scale;
}

- (int)widthInPixels {
    return self.size.width * self.scale;
}

@end
