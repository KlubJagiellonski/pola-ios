//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPProductImageManager : NSObject

- (void)saveImage:(UIImage *)image forKey:(NSString *)key index:(int)index;

- (BOOL)isImageExistForKey:(NSString *)key index:(int)index;

- (UIImage *)retrieveImageForKey:(NSString *)key index:(int)index small:(BOOL)small;

- (NSArray *)createImagePathArrayForKey:(NSString *)key imageCount:(int)imageCount;

@end