#import "BPMainProggressView.h"
#import "BPTheme.h"


const int MAIN_PROGRESS_HEIGHT = 20;
const int MAIN_PROGRESS_TITLE_MARGIN = 10;


@interface BPMainProggressView ()
@property(nonatomic, readonly) UIView *filledProgressView;
@property(nonatomic, readonly) UILabel *percentLabel;
@end

@implementation BPMainProggressView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [BPTheme lightBackgroundColor];

        _filledProgressView = [[UIView alloc] initWithFrame:CGRectZero];
        _filledProgressView.backgroundColor = [BPTheme actionColor];
        [self addSubview:_filledProgressView];

        _percentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _percentLabel.font = [BPTheme captionFont];
        _percentLabel.textColor = [BPTheme clearColor];
        [self addSubview:_percentLabel];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = CGRectZero;
    rect.origin = CGPointMake(0, 0);
    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) * self.progress, CGRectGetHeight(self.bounds));
    self.filledProgressView.frame = rect;

    rect = self.percentLabel.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - MAIN_PROGRESS_TITLE_MARGIN - CGRectGetWidth(self.percentLabel.frame);
    rect.origin.y = CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(self.percentLabel.bounds) / 2;
    self.percentLabel.frame = rect;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;

    int progressInt = (int) (progress * 100);
    self.percentLabel.text = [NSString stringWithFormat:@"%i pkt.", progressInt];
    [self.percentLabel sizeToFit];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.height = MAIN_PROGRESS_HEIGHT;
    return size;
}

@end