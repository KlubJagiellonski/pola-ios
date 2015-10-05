#import <AVFoundation/AVFoundation.h>
#import "BPScanCodeView.h"
#import "BPStackView.h"

const int STATUS_BAR_HEIGHT = 20;

@implementation BPScanCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _stackView = [[BPStackView alloc] initWithFrame:CGRectZero];
        [self addSubview:_stackView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.stackView.frame = CGRectMake(0, STATUS_BAR_HEIGHT, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - STATUS_BAR_HEIGHT);
}


- (void)setVideoLayer:(AVCaptureVideoPreviewLayer *)videoLayer {
    if(_videoLayer == videoLayer) {
        return;
    }

    [_videoLayer removeFromSuperlayer];
    _videoLayer = videoLayer;
    [videoLayer setFrame:self.layer.bounds];
    [self.layer addSublayer:videoLayer];

    [self bringSubviewToFront:self.stackView];
}


- (void)addVideoPreviewLayer:(AVCaptureVideoPreviewLayer *)layer {
    self.videoLayer = layer;

    [layer setFrame:self.layer.bounds];

    [self.layer addSublayer:layer];

    [self bringSubviewToFront:self.stackView];
}

- (void)changeVideoLayerHeightWithAnimationDuration:(CGFloat)duration {
    CGRect rect = self.videoLayer.bounds;
    CGRect newRect = rect;
    newRect.size.height = CGRectGetHeight(self.bounds) - [self.stackView cardViewsHeight];

    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"bounds";
    animation.fromValue = [NSValue valueWithCGRect:rect];
    animation.toValue = [NSValue valueWithCGRect:newRect];
    animation.duration = duration;
    animation.fillMode = kCAFillModeForwards;

    [self.videoLayer addAnimation:animation forKey:@"basic"];
}

@end