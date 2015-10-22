//
// Created by Paweł Janeczek on 22/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPTheme.h"
#import "UIColor+BPAdditions.h"


@implementation BPTheme {

}
+ (UIColor *)lightBackground {
    return [UIColor colorWithHexString:@"CCCCCC"];
}

+ (UIColor *)actionColor {
    return [UIColor colorWithHexString:@"D8002F"];
}

+ (UIColor *)strongBackground {
    return [UIColor colorWithHexString:@"666666"];
}

+ (UIColor *)clearBackground {
    return [UIColor whiteColor];
}
@end