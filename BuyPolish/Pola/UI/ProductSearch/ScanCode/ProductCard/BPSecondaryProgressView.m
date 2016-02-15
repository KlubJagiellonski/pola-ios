#import "BPSecondaryProgressView.h"
#import "BPTheme.h"


const int SECONDARY_PROGRESS_HEIGHT = 20;
const int SECONDARY_PROGRESS_TITLE_MARGIN = 10;


@interface BPSecondaryProgressView ()
@property(nonatomic, readonly) UIView *filledProgressView;
@property(nonatomic, readonly) UILabel *percentLabel;
@property(nonatomic) CGFloat progressValue;
@end


@implementation BPSecondaryProgressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.progressValue = 1.f;

        _filledProgressView = [[UIView alloc] initWithFrame:CGRectZero];
        _filledProgressView.backgroundColor = [BPTheme lightBackgroundColor];
        [self addSubview:_filledProgressView];

        _percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _percentLabel.font = [BPTheme captionFont];
        _percentLabel.textColor = [BPTheme defaultTextColor];
        _percentLabel.text = @"?";
        [_percentLabel sizeToFit];
        [self addSubview:_percentLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = CGRectZero;
    rect.origin = CGPointMake(0, 0);
    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) * self.progressValue, CGRectGetHeight(self.bounds));
    self.filledProgressView.frame = rect;

    int percentLabelRequiredSpace = (int) (CGRectGetWidth(self.percentLabel.bounds) + 2 * SECONDARY_PROGRESS_TITLE_MARGIN);

    rect = self.percentLabel.frame;
    if (percentLabelRequiredSpace > CGRectGetWidth(self.filledProgressView.frame)) {
        rect.origin.x = CGRectGetMaxX(self.filledProgressView.frame) + SECONDARY_PROGRESS_TITLE_MARGIN;
    } else {
        rect.origin.x = CGRectGetMaxX(self.filledProgressView.frame) - SECONDARY_PROGRESS_TITLE_MARGIN - CGRectGetWidth(self.percentLabel.bounds);
    }
    rect.origin.y = CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(self.percentLabel.bounds) / 2;
    self.percentLabel.frame = rect;
}

- (void)setProgress:(NSNumber *)progress {
    self.progressValue = progress ? progress.intValue / 100.f : 1.f;

    if (progress) {
        self.percentLabel.text = [NSString stringWithFormat:@"%i%%", progress.intValue];
    } else {
        self.percentLabel.text = @"?";
    }
    [self.percentLabel sizeToFit];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}


- (CGSize)sizeThatFits:(CGSize)size {
    size.height = SECONDARY_PROGRESS_HEIGHT;
    return size;
}

- (void)setFillColor:(UIColor *)fillColor {
    self.filledProgressView.backgroundColor = fillColor;
}

- (void)setPercentColor:(UIColor *)percentColor {
    self.percentLabel.textColor = percentColor;
}
@end