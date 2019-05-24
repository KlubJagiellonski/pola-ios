//
//  UIView+SafeAreaInsets.m
//  Pola
//
//  Created by Marcin Stepnowski on 24/05/2019.
//  Copyright © 2019 PJMS. All rights reserved.
//

#import "UIView+SafeAreaInsets.h"
#import "UIApplication+BPStatusBarHeight.h"

@implementation UIView (SafeAreaInsets)

- (CGFloat)topSafeAreaInset {
    if (@available(iOS 11, *)) {
        return self.safeAreaInsets.top;
    } else {
        return [UIApplication statusBarHeight];
    }
}

@end
