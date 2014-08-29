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


#import "NSLayoutConstraint+PLVisualAttributeConstraints.h"
#import "PLAttributeConstraintVisualFormatParser.h"
#import "PLAttributeConstraintVisualFormatLexer.h"

#pragma mark - STATIC VARIABLES ========================================================================================

// Lexer/parser pair is created only once

static PLAttributeConstraintVisualFormatLexer *__lexer;
static PLAttributeConstraintVisualFormatParser *__parser;

#pragma mark - =========================================================================================================


@implementation NSLayoutConstraint (PLVisualAttributeConstraints)

+ (void)load {
    __lexer = [[PLAttributeConstraintVisualFormatLexer alloc] initWithText:@""];
    __parser = [[PLAttributeConstraintVisualFormatParser alloc] initWithLexer:__lexer];
}

#pragma mark -- Interface

+ (instancetype)attributeConstraintWithVisualFormat:(NSString *)format views:(NSDictionary *)views {
    return [self attributeConstraintWithVisualFormat:format views:views priority:UILayoutPriorityRequired];
}

+ (NSArray *)attributeConstraintsWithVisualFormatsArray:(NSArray *)formatsArray views:(NSDictionary *)views priority:(UILayoutPriority)priority {
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:formatsArray.count];
    for (NSString *format in formatsArray) {
        NSLayoutConstraint *constraint = [self attributeConstraintWithVisualFormat:format views:views priority:priority];
        if (constraint) {
            [constraints addObject:constraint];
        }
    }
    return constraints;
}

+ (NSArray *)attributeConstraintsWithVisualFormatsArray:(NSArray *)formatsArray views:(NSDictionary *)views {
    return [self attributeConstraintsWithVisualFormatsArray:formatsArray views:views priority:UILayoutPriorityRequired];
}

+ (instancetype)attributeConstraintWithVisualFormat:(NSString *)format views:(NSDictionary *)views priority:(UILayoutPriority)priority {
    __lexer.text = format;
    NSLayoutConstraint *constraint = [__parser parseConstraintWithViews:views];
    constraint.priority = priority;
    return constraint;
}

@end
