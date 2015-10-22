//
// Created by Paweł Janeczek on 22/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPTheme : NSObject

+ (UIColor *)lightBackgroundColor;
+ (UIColor *)actionColor;
+ (UIColor *)strongBackgroundColor;

+ (UIColor *)clearColor;

+ (UIColor *)defaultTextColor;

+ (UIFont *)titleFont;

+ (UIFont *)captionFont;

+ (UIFont *)normalFont;

+ (UIFont *)buttonFont;

+ (UIColor *)mediumBackgroundColor;
@end