#import "BPCheckRow.h"
#import "BPTheme.h"

const int CHECK_ROW_HORIZONTAL_MARGIN = 7;

@interface BPCheckRow ()
@property(nonatomic, readonly) UIImageView *checkImageView;
@property(nonatomic, readonly) UILabel *textLabel;
@end

@implementation BPCheckRow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _checkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _checkImageView.tintColor = [BPTheme defaultTextColor];
        [self addSubview:_checkImageView];

        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [BPTheme normalFont];
        _textLabel.textColor = [BPTheme defaultTextColor];
        [self addSubview:_textLabel];
        
        self.accessibilityTraits = UIAccessibilityTraitStaticText;
        self.isAccessibilityElement = true;
        
        [self setChecked:nil];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.checkImageView.frame;
    rect.origin.x = 0;
    rect.origin.y = CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(rect) / 2;
    self.checkImageView.frame = rect;

    rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.checkImageView.frame) + CHECK_ROW_HORIZONTAL_MARGIN;
    rect.origin.y = CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(rect) / 2;
    self.textLabel.frame = rect;
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
    [self.textLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)setChecked:(NSNumber *)checked {
    UIImage *image;
    NSString *accessibilityValueKey;
    if (!checked) {
        image = [UIImage imageNamed:@"NoneIcon"];
        accessibilityValueKey = @"Accessibility.CheckRow.Unknow";
    } else {
        image = [UIImage imageNamed:checked.boolValue ? @"TrueIcon" : @"FalseIcon"];
        accessibilityValueKey = checked.boolValue ? @"Accessibility.CheckRow.Selected" : @"Accessibility.CheckRow.NotSelected";
    }
    self.checkImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.checkImageView.accessibilityValue = NSLocalizedString(accessibilityValueKey, @"");
    [self.checkImageView sizeToFit];
    [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.width = CGRectGetWidth(self.checkImageView.bounds) + CHECK_ROW_HORIZONTAL_MARGIN + CGRectGetWidth(self.textLabel.bounds);
    size.height = MAX(CGRectGetHeight(self.checkImageView.bounds), CGRectGetHeight(self.textLabel.bounds));
    return size;
}

- (NSString *)accessibilityValue {
    return self.checkImageView.accessibilityValue;
}

- (NSString *)accessibilityLabel {
    return self.textLabel.text;
}

@end
