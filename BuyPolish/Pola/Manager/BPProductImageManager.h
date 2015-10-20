//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPProductImageManager : NSObject

- (void)saveImage:(UIImage *)image forBarcode:(NSString *)barcode index:(int)index;

- (BOOL)isImageExistForBarcode:(NSString *)barcode index:(int)index;

- (UIImage *)retrieveImageForBarcode:(NSString *)barcode index:(int)index small:(BOOL)small;

- (NSArray *)createImagePathArrayForBarcode:(NSString *)barcode imageCount:(int)imageCount;

@end