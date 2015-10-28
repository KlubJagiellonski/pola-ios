#import <AVFoundation/AVFoundation.h>
#import "BPScanCodeView.h"
#import "BPStackView.h"
#import "BPConst.h"
#import "BPTheme.h"

const int SCAN_CODE_MARGIN = 15;
const int INFO_TEXT_LABEL_BOTTOM_MARGIN = 50;

@interface BPScanCodeView ()
@property(nonatomic, readonly) UIView *rectangleView;
@property(nonatomic, readonly) UIView *dimView;
@property(nonatomic, readonly) UILabel *infoTextLabel;
@end

@implementation BPScanCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dimView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GradientImage"]];
        [self addSubview:_dimView];

        _rectangleView = [[UIView alloc] initWithFrame:CGRectZero];
        _rectangleView.layer.borderWidth = 1.f;
        _rectangleView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self addSubview:_rectangleView];

        _infoTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _infoTextLabel.numberOfLines = 2;
        _infoTextLabel.text = NSLocalizedString(@"Scan barcode", @"Zeskanuj kod kreskowy");
        _infoTextLabel.font = [BPTheme titleFont];
        _infoTextLabel.textColor = [BPTheme clearColor];
        _infoTextLabel.textAlignment = NSTextAlignmentCenter;
        [_infoTextLabel sizeToFit];
        [self addSubview:_infoTextLabel];

        _menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuButton setImage:[UIImage imageNamed:@"BurgerIcon"] forState:UIControlStateNormal];
        [_menuButton sizeToFit];
        [self addSubview:_menuButton];

        _stackView = [[BPStackView alloc] initWithFrame:CGRectZero];
        [self addSubview:_stackView];

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

    rect = self.menuButton.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - SCAN_CODE_MARGIN - CGRectGetWidth(rect);
    rect.origin.y = STATUS_BAR_HEIGHT + SCAN_CODE_MARGIN;
    self.menuButton.frame = rect;

    rect = self.infoTextLabel.frame;
    rect.size.width = CGRectGetWidth(self.bounds);
    rect.origin.x = 0;
    rect.origin.y = CGRectGetHeight(self.bounds) - INFO_TEXT_LABEL_BOTTOM_MARGIN - CGRectGetHeight(rect);
    self.infoTextLabel.frame = rect;
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
    [UIView animateWithDuration:0.3f animations:^{
        self.infoTextLabel.alpha = visible ? 1.f : 0.f;
    }];
}

@end