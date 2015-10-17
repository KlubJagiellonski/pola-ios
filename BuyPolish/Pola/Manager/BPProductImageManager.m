//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPProductImageManager.h"

const float SMALL_IMAGE_WIDTH = 50;

@implementation BPProductImageManager

- (void)saveImage:(UIImage *)image forBarcode:(NSString *)barcode index:(int)index {
    [UIImagePNGRepresentation(image) writeToFile:[self imagePathForBarcode:barcode index:index small:NO] atomically:NO];

    UIImage *smallImage = [self imageWithImage:image scaledToSize:[self createSmallSizeForImage:image]];
    [UIImagePNGRepresentation(smallImage) writeToFile:[self imagePathForBarcode:barcode index:index small:YES] atomically:NO];
}

- (CGSize)createSmallSizeForImage:(UIImage *)image {
    float ratio = image.size.height / image.size.width;
    return CGSizeMake(SMALL_IMAGE_WIDTH, image.size.width * ratio);
}

- (BOOL)isImageExistForBarcode:(NSString *)barcode index:(int)index {
    NSString *imagePath = [self imagePathForBarcode:barcode index:index small:YES];
    return [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
}

- (UIImage *)retrieveImageForBarcode:(NSString *)barcode index:(int)index small:(BOOL)small {
    NSString *imagePath = [self imagePathForBarcode:barcode index:index small:small];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    return [UIImage imageWithData:data];
}

- (NSString *)imagePathForBarcode:(NSString *)barcode index:(int)index small:(BOOL)small {
    NSArray *paths = NSSearchPathForDirectoriesInDomains
            (NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directory = paths[0];
    NSString *filename = [NSString stringWithFormat:@"%@_%i_%i", barcode, index, small];
    return [directory stringByAppendingPathComponent:filename];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end