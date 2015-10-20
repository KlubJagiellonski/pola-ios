//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPProductImageManager.h"

const float SMALL_IMAGE_WIDTH = 200;
const float LARGE_IMAGE_WIDTH = 800;

@implementation BPProductImageManager

- (void)saveImage:(UIImage *)image forBarcode:(NSString *)barcode index:(int)index {
    UIImage *largeImage = [self imageWithImage:image scaledToWidth:LARGE_IMAGE_WIDTH];
    [UIImagePNGRepresentation(largeImage) writeToFile:[self imagePathForBarcode:barcode index:index small:NO] atomically:NO];

    UIImage *smallImage = [self imageWithImage:image scaledToWidth:SMALL_IMAGE_WIDTH];
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

- (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)width {
    float oldWidth = sourceImage.size.width;
    float scaleFactor = width / oldWidth;

    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;

    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSArray *)createImagePathArrayForBarcode:(NSString *)barcode imageCount:(int)imageCount {
    NSMutableArray *pathArray = [NSMutableArray arrayWithCapacity:(NSUInteger) imageCount];
    for (int i = 0; i < imageCount; ++i) {
        NSString *imagePath = [self imagePathForBarcode:barcode index:i small:NO];
        [pathArray addObject:imagePath];
    }
    return pathArray;
}

@end