//
// Created by Paweł on 22/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "UILabel+BPAdditions.h"


@implementation UILabel (BPAdditions)

- (CGFloat)heightForWidth:(CGFloat)width {
    NSString *aLabelTextString = [self text];
    UIFont *aLabelFont = [self font];
    return [aLabelTextString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{
                                           NSFontAttributeName : aLabelFont
                                       }
                                          context:nil].size.height;
}

@end