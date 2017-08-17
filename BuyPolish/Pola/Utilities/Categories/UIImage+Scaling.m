#import "UIImage+Scaling.h"

@implementation UIImage (Scaling)

- (UIImage *)scaledToWidth:(float)width {
    float oldWidth = self.size.width;
    float scaleFactor = width / oldWidth;
    
    float newHeight = self.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [self drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaledToHeight:(float)height {
    float oldHeight = self.size.height;
    float scaleFactor = height / oldHeight;
    
    float newWidth = self.size.width * scaleFactor;
    float newHeight = oldHeight * scaleFactor;
    
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
