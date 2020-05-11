#import "BPAboutViewControllerDoubleCell.h"
#import "BPDoubleAboutRow.h"
#import "BPTheme.h"

@interface BPAboutViewControllerDoubleCell ()
@property (nonatomic) UIButton *firstButton;
@property (nonatomic) UIButton *secondButton;
@end

@implementation BPAboutViewControllerDoubleCell

#pragma mark - UITableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self applyStyleForButton:_firstButton];
        [self.contentView addSubview:_firstButton];

        _secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self applyStyleForButton:_secondButton];
        [self.contentView addSubview:_secondButton];

        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat buttonHeight = self.contentView.frame.size.height - 2 * kAboutCellWhiteBackgroundVerticalMargin;
    CGFloat buttonWidht = (self.contentView.frame.size.width - 3 * kAboutCellWhiteBackgroundHorizontalMargin) / 2;
    self.firstButton.frame = CGRectMake(
        kAboutCellWhiteBackgroundHorizontalMargin, kAboutCellWhiteBackgroundVerticalMargin, buttonWidht, buttonHeight);
    self.secondButton.frame =
        CGRectMake(kAboutCellWhiteBackgroundHorizontalMargin + CGRectGetMaxX(self.firstButton.frame),
                   kAboutCellWhiteBackgroundVerticalMargin,
                   buttonWidht,
                   buttonHeight);
}

#pragma mark - Getters/Setters

- (void)setAboutRowInfo:(BPAboutRow *)aboutRowInfo {
    [super setAboutRowInfo:aboutRowInfo];
    if ([aboutRowInfo isKindOfClass:[BPDoubleAboutRow class]]) {
        BPDoubleAboutRow *doubleRowInfo = (BPDoubleAboutRow *)aboutRowInfo;

        [self.firstButton setTitle:doubleRowInfo.title forState:UIControlStateNormal];
        [self.firstButton addTarget:doubleRowInfo.target
                             action:doubleRowInfo.action
                   forControlEvents:UIControlEventTouchUpInside];

        [self.secondButton setTitle:doubleRowInfo.secondTitle forState:UIControlStateNormal];
        [self.secondButton addTarget:doubleRowInfo.target
                              action:doubleRowInfo.secondAction
                    forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Private

- (void)applyStyleForButton:(UIButton *)button {
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    button.backgroundColor = [UIColor whiteColor];
    [button setTitleColor:[BPTheme defaultTextColor] forState:UIControlStateNormal];
    button.titleLabel.font = [BPTheme normalFont];
}

@end
