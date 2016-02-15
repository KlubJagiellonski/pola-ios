#import "BPTheme.h"
#import "UIColor+BPAdditions.h"


@implementation BPTheme {

}
+ (UIColor *)lightBackgroundColor {
    return [UIColor colorWithHexString:@"CCCCCC"];
}

+ (UIColor *)actionColor {
    return [UIColor colorWithHexString:@"D8002F"];
}

+ (UIColor *)strongBackgroundColor {
    return [UIColor colorWithHexString:@"666666"];
}

+ (UIColor *)clearColor {
    return [UIColor whiteColor];
}

+ (UIColor *)defaultTextColor {
    return [UIColor colorWithHexString:@"333333"];
}

+ (UIColor *)mediumBackgroundColor {
    return [UIColor colorWithHexString:@"E9E8E7"];
}

//"Lato-Semibold",
//"Lato-Regular",
//"Lato-Light"

+ (UIFont *)titleFont {
    return [UIFont fontWithName:@"Lato-Regular" size:16];
}

+ (UIFont *)captionFont {
    return [UIFont fontWithName:@"Lato-Light" size:12];
}

+ (UIFont *)normalFont {
    return [UIFont fontWithName:@"Lato-Light" size:14];
}

+ (UIFont *)buttonFont {
    return [UIFont fontWithName:@"Lato-Semibold" size:14];
}

@end