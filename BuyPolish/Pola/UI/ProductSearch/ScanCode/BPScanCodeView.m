#import "BPScanCodeView.h"
#import "BPStackView.h"
#import "UILabel+BPAdditions.h"
#import "UIView+SafeAreaInsets.h"
#import <Pola-Swift.h>

const int SCAN_CODE_MARGIN = 15;
const int INFO_TEXT_LABEL_BOTTOM_MARGIN = 50;
const int SCAN_CODE_TEACH_BUTTON_OFFSET = 10;
const int SCAN_CODE_TEACH_BUTTON_HEIGHT = 35;

@interface BPScanCodeView ()
@property (nonatomic, readonly) UIView *dimView;
@end

@implementation BPScanCodeView
@synthesize flashlightButtonHidden = _flashlightButtonHidden;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dimView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GradientImage"]];
        [self addSubview:_dimView];

        _rectangleView = [[UIView alloc] initWithFrame:CGRectZero];
        _rectangleView.layer.borderWidth = 1.f;
        _rectangleView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _rectangleView.accessibilityTraits = UIAccessibilityTraitNotEnabled;
        _rectangleView.isAccessibilityElement = YES;
        _rectangleView.accessibilityHint = NSLocalizedString(@"Accessibility.RectangleHint", @"");
        [self addSubview:_rectangleView];

        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LogoIcon"]];
        [_logoImageView sizeToFit];
        [self addSubview:_logoImageView];

        _infoTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoTextLabel.numberOfLines = 4;
        _infoTextLabel.font = [BPTheme titleFont];
        _infoTextLabel.textColor = [BPTheme clearColor];
        _infoTextLabel.textAlignment = NSTextAlignmentCenter;
        [_infoTextLabel sizeToFit];
        [self configureInfoLabelForMode:BPScanCodeViewLabelModeScan];
        [self addSubview:_infoTextLabel];

        _stackView = [[BPStackView alloc] initWithFrame:CGRectZero];
        [self addSubview:_stackView];

        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashButton.accessibilityLabel = NSLocalizedString(@"Accessibility.Flash", nil);
        [_flashButton setImage:[UIImage imageNamed:@"FlashIcon"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"FlashSelectedIcon"] forState:UIControlStateSelected];
        [_flashButton sizeToFit];
        [self insertSubview:_flashButton belowSubview:_logoImageView];

        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuButton.accessibilityLabel = NSLocalizedString(@"Accessibility.Info", nil);
        [_menuButton setImage:[UIImage imageNamed:@"BurgerIcon"] forState:UIControlStateNormal];
        [_menuButton sizeToFit];
        [self addSubview:_menuButton];

        _keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _keyboardButton.accessibilityLabel = NSLocalizedString(@"Accessibility.WriteCode", nil);
        [_keyboardButton setImage:[UIImage imageNamed:@"KeyboardIcon"] forState:UIControlStateNormal];
        [_keyboardButton setImage:[UIImage imageNamed:@"KeyboardSelectedIcon"] forState:UIControlStateSelected];
        [_keyboardButton sizeToFit];
        [self addSubview:_keyboardButton];

        _teachButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _teachButton.accessibilityLabel = NSLocalizedString(@"Accessibility.TeachPola", nil);
        _teachButton.titleLabel.font = [BPTheme buttonFont];
        _teachButton.layer.borderColor = [[BPTheme defaultTextColor] CGColor];
        _teachButton.layer.borderWidth = 1;
        [_teachButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_teachButton setBackgroundImage:[BPUtilities imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.7]]
                                forState:UIControlStateNormal];
        [_teachButton setBackgroundImage:[BPUtilities imageWithColor:[UIColor whiteColor]]
                                forState:UIControlStateHighlighted];
        [_teachButton sizeToFit];
        [_teachButton setHidden:YES];
        [self addSubview:_teachButton];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.stackView.frame = self.bounds;

    self.dimView.frame = self.bounds;

    CGRect rect = self.rectangleView.frame;
    rect.size.width = CGRectGetWidth(self.bounds) / 1.4f;
    rect.size.height = rect.size.width / 2;
    rect.origin.x = CGRectGetWidth(self.bounds) / 2 - CGRectGetWidth(rect) / 2;
    rect.origin.y = CGRectGetHeight(self.bounds) / 2 - CGRectGetHeight(rect);
    self.rectangleView.frame = rect;

    CGFloat topY = self.topSafeAreaInset + SCAN_CODE_MARGIN;
    rect = self.keyboardButton.frame;
    rect.origin.x = SCAN_CODE_MARGIN;
    rect.origin.y = topY;
    self.keyboardButton.frame = rect;

    rect = self.flashButton.frame;
    rect.origin.x = SCAN_CODE_MARGIN;
    rect.origin.y = SCAN_CODE_MARGIN + CGRectGetMaxY(self.keyboardButton.frame);
    self.flashButton.frame = rect;

    rect = self.menuButton.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - SCAN_CODE_MARGIN - CGRectGetWidth(rect);
    rect.origin.y = topY;
    self.menuButton.frame = rect;

    rect = self.logoImageView.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) / 2 - CGRectGetWidth(rect) / 2;
    rect.origin.y =
        CGRectGetMinY(self.menuButton.frame) + CGRectGetHeight(self.menuButton.bounds) / 2 - CGRectGetHeight(rect) / 2;
    self.logoImageView.frame = rect;

    rect = self.infoTextLabel.frame;
    rect.size.width = CGRectGetWidth(self.bounds) - 2 * SCAN_CODE_MARGIN;
    rect.size.height = [self.infoTextLabel heightForWidth:rect.size.width];
    rect.origin.x = SCAN_CODE_MARGIN;
    rect.origin.y = CGRectGetHeight(self.bounds) - INFO_TEXT_LABEL_BOTTOM_MARGIN - CGRectGetHeight(rect);
    self.infoTextLabel.frame = rect;

    rect = self.teachButton.frame;
    rect.size.height = SCAN_CODE_TEACH_BUTTON_HEIGHT;
    rect.size.width = CGRectGetWidth(self.bounds) - (SCAN_CODE_MARGIN * 2);
    rect.origin.x = SCAN_CODE_MARGIN;
    self.teachButton.frame = rect;
}

- (void)setVideoLayer:(AVCaptureVideoPreviewLayer *)videoLayer {
    if (_videoLayer == videoLayer) {
        return;
    }

    [_videoLayer removeFromSuperlayer];
    _videoLayer = videoLayer;
    [videoLayer setFrame:self.layer.bounds];
    [self.layer insertSublayer:videoLayer atIndex:0];
}

- (void)setInfoTextVisible:(BOOL)visible {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         self.infoTextLabel.alpha = visible ? 1.f : 0.f;
                     }];
}

- (void)configureInfoLabelForMode:(BPScanCodeViewLabelMode)mode {
    if (mode == BPScanCodeViewLabelModeScan) {
        self.infoTextLabel.text = NSLocalizedString(@"Scan barcode", nil);
    } else {
        self.infoTextLabel.text = NSLocalizedString(@"Type 13 digits", nil);
    }
}

- (void)setButtonsVisible:(BOOL)visible animation:(BOOL)animation {
    CGFloat alpha = visible ? 1.f : 0.f;
    [UIView animateWithDuration:animation ? 0.2f : 0.f
                     animations:^{
                         self.menuButton.alpha = alpha;
                         self.flashButton.alpha = alpha;
                         self.keyboardButton.alpha = alpha;
                         if (visible) {
                             self.teachButton.alpha = alpha;
                         }
                     }];

    if (!visible) {
        self.teachButton.alpha = alpha;
    }
}

- (BOOL)isFlashlightButtonHidden {
    return self.flashButton.hidden;
}

- (void)setFlashlightButtonHidden:(BOOL)flashlightButtonHidden {
    _flashlightButtonHidden = flashlightButtonHidden;
    self.flashButton.hidden = flashlightButtonHidden;
}

- (void)updateTeachButtonWithVisible:(BOOL)visible title:(NSString *)title cardsHeight:(CGFloat)cardsHeight {
    if (visible) {
        [self.teachButton setTitle:title forState:UIControlStateNormal];
        CGRect rect = self.teachButton.frame;
        rect.origin.y =
            CGRectGetHeight(self.bounds) - cardsHeight - SCAN_CODE_TEACH_BUTTON_HEIGHT - SCAN_CODE_TEACH_BUTTON_OFFSET;
        self.teachButton.frame = rect;
    }
    [self.teachButton setHidden:!visible];
    [self.teachButton setNeedsLayout];
    [self.teachButton layoutIfNeeded];
}

- (CGFloat)cardsHeight {
    return self.stackView.cardsHeight;
}

@end
