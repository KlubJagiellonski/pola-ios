/*

 Copyright (c) 2013, Kamil Jaworski, Polidea
 All rights reserved.

 mailto: kamil.jaworski@gmail.com

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 * Neither the name of the Polidea nor the
 names of its contributors may be used to endorse or promote products
 derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY KAMIL JAWORSKI, POLIDEA ''AS IS'' AND ANY
 EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL KAMIL JAWORSKI, POLIDEA BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

 */


#import "PLConstraintLayoutAttributeMapper.h"

@implementation PLConstraintLayoutAttributeMapper {

}

+ (NSLayoutAttribute)attributeFromString:(NSString *)attributeName {

    attributeName = [attributeName lowercaseString];

    if ([attributeName isEqualToString:@"left"]) {
        return NSLayoutAttributeLeft;
    } else if ([attributeName isEqualToString:@"top"]) {
        return NSLayoutAttributeTop;
    } else if ([attributeName isEqualToString:@"right"]) {
        return NSLayoutAttributeRight;
    } else if ([attributeName isEqualToString:@"bottom"]) {
        return NSLayoutAttributeBottom;
    } else if ([attributeName isEqualToString:@"leading"]) {
        return NSLayoutAttributeLeading;
    } else if ([attributeName isEqualToString:@"trailing"]) {
        return NSLayoutAttributeTrailing;
    } else if ([attributeName isEqualToString:@"width"]) {
        return NSLayoutAttributeWidth;
    } else if ([attributeName isEqualToString:@"height"]) {
        return NSLayoutAttributeHeight;
    } else if ([attributeName isEqualToString:@"centerx"]) {
        return NSLayoutAttributeCenterX;
    } else if ([attributeName isEqualToString:@"centery"]) {
        return NSLayoutAttributeCenterY;
    } else if ([attributeName isEqualToString:@"baseline"]) {
        return NSLayoutAttributeBaseline;
    } else {
        return NSLayoutAttributeNotAnAttribute;
    }

}

@end
