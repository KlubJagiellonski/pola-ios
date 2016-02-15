#import "BPAboutViewControllerCell.h"
#import "BPTheme.h"

CGFloat const WHITE_BACKGROUND_HORIZONTAL_MARGIN = 8.0f;
CGFloat const WHITE_BACKGROUND_VERTICAL_MARGIN = 16.0f;
CGFloat const LABEL_X_OFFSET = 20.0f;

@interface BPAboutViewControllerCell ()
@property (nonatomic) UIView *whiteBackgroundView;
@end

@implementation BPAboutViewControllerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Configure and insert whiteBackgroundView
        _whiteBackgroundView = [UIView new];
        _whiteBackgroundView.backgroundColor = [UIColor whiteColor];
        [self.contentView insertSubview:_whiteBackgroundView belowSubview:self.textLabel];

        // Configure textLabel
        self.textLabel.textColor = [BPTheme defaultTextColor];
        self.textLabel.font = [BPTheme normalFont];

        // Set background color
        self.backgroundColor = [BPTheme mediumBackgroundColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // Set sizes of view
    self.whiteBackgroundView.frame = CGRectInset(self.bounds, WHITE_BACKGROUND_VERTICAL_MARGIN, WHITE_BACKGROUND_HORIZONTAL_MARGIN);
    self.textLabel.frame = CGRectOffset(self.whiteBackgroundView.frame, LABEL_X_OFFSET, 0);
}

@end
