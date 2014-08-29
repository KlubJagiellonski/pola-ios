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


#import <Foundation/Foundation.h>
#import <UIKit/NSLayoutConstraint.h>

/*

    Abstract:

        In standard SDK NSLayoutConstraint has static method

            + constraintsWithVisualFormat:options:metrics:views:

        which you can use to parse string such as

            H:|-nameLabel-scoreLabel-icon-|

        into array of layout constraints.

        Using this "standard" visual format, however, you cannot express some special cases.
        When you stumble upon such a problem, you have to resort to very unhandy method:

            +constraintWithItem:attribute:relatedBy:toItem:attribute:multiplier:constant

        which takes just about gazilion arguments and is very unreadable.

        Using this small lib, you can use it indirectly, using convenient, another visual format.

        For example:

            UIView *firstView = ...
            UIView *secondView = ... // those views are from... somewhere :)

            // Standard method

            NSLayoutConstraint* constraint = [NSLayoutConstraint constraintWithItem:firstView
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:secondView
                                         attribute:NSLayoutAttributeTop
                                        multiplier:2
                                          constant:12];

            // Using this small lib
            NSDictionary *views = @{
                @"first" : firstView,
                @"second" : secondView
            };

            NSLayoutConstraint* constraint = [NSLayoutConstraint attributeConstraintWithVisualFormat: @"first.top == second.top * 2 + 12"
                                                                    views: views];


            // At first sight, you see that it's more readable. It's even more helpful in real-life situations,
            // where you want to create many constraints, so you would use it like that:

            // Using this small lib
            NSDictionary *views = @{
                @"first" : firstView,
                @"second" : secondView
            };

            NSArray* constraints = [NSLayoutConstraint attributeConstraintsWithVisualFormatsArray: @[
                        @"first.top == second.top * 2 + 12"
                        @"first.left == second.left + 14"
                        @"first.width == second.width * 2"
                    ]
                    views: views];


 */


@interface NSLayoutConstraint (PLVisualAttributeConstraints)

/*

    format: Visual format to create constraint from
    views: Dictionary of views (the very same that you pass to
            constraintsWithVisualFormat:options:metrics:views: as the very last argument)


 */

+ (instancetype)attributeConstraintWithVisualFormat:(NSString *)format views:(NSDictionary *)views;
+ (instancetype)attributeConstraintWithVisualFormat:(NSString *)format views:(NSDictionary *)views priority:(UILayoutPriority)priority;

+ (NSArray *)attributeConstraintsWithVisualFormatsArray:(NSArray *)formatsArray views:(NSDictionary *)views priority:(UILayoutPriority)priority;
+ (NSArray *)attributeConstraintsWithVisualFormatsArray:(NSArray *)formatsArray views:(NSDictionary *)views;

@end

