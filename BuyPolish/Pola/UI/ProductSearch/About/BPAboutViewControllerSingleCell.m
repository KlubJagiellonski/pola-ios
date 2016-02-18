#import "BPAboutViewControllerSingleCell.h"
#import "BPTheme.h"
#import "BPAboutRow.h"

CGFloat const kLabelXOffset = 20.0f;

@interface BPAboutViewControllerSingleCell ()
@property (nonatomic) UIView *whiteBackgroundView;
@end

@implementation BPAboutViewControllerSingleCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        // Configure and insert whiteBackgroundView
        _whiteBackgroundView = [UIView new];
        _whiteBackgroundView.backgroundColor = [UIColor whiteColor];
        [self.contentView insertSubview:_whiteBackgroundView belowSubview:self.textLabel];

        // Configure textLabel
        self.textLabel.textColor = [BPTheme defaultTextColor];
        self.textLabel.font = [BPTheme normalFont];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // Set sizes of view
    self.whiteBackgroundView.frame = CGRectInset(self.bounds, kAboutCellWhiteBackgroundHorizontalMargin, kAboutCellWhiteBackgroundVerticalMargin);
    self.textLabel.frame = CGRectOffset(self.whiteBackgroundView.frame, kLabelXOffset, 0);
}

- (void)setAboutRowInfo:(BPAboutRow *)aboutRowInfo {
    [super setAboutRowInfo:aboutRowInfo];
    self.textLabel.text = aboutRowInfo.title;
}

@end
