//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPProductImageManager : NSObject

- (void)saveImage:(UIImage *)image forKey:(NSNumber *)key index:(int)index;

- (BOOL)isImageExistForKey:(NSNumber *)key index:(int)index;

- (UIImage *)retrieveImageForKey:(NSNumber *)key index:(int)index small:(BOOL)small;

- (NSArray *)createImagePathArrayForKey:(NSNumber *)key imageCount:(int)imageCount;

@end