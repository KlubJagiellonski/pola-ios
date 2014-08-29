#import "BPNoProductInfoView.h"


@interface BPNoProductInfoView ()

@property(nonatomic, readonly) UILabel *noProductInfoLabel;
@end


@implementation BPNoProductInfoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _noProductInfoLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _noProductInfoLabel.text = NSLocalizedString(@"Sorry :(\nWe are working as hard as we can to gather info about all of the products, but you can still sometimes found such view.", @"Sorry :(\nWe are working as hard as we can to gather info about all of the products, but you can still sometimes found such view.");
        _noProductInfoLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        _noProductInfoLabel.textColor = [UIColor blackColor];
        [self addSubview:_noProductInfoLabel];
    }

    return self;
}

@end