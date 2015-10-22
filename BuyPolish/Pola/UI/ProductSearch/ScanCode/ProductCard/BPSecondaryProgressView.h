//
// Created by Paweł on 21/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPSecondaryProgressView : UIView

- (void)setProgress:(NSNumber *)progress;

- (void)setFillColor:(UIColor *)fillColor;

- (void)setPercentColor:(UIColor *)percentColor;
@end