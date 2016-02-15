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