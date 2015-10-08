#import <AVFoundation/AVFoundation.h>
#import "BPScanCodeView.h"
#import "BPStackView.h"

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

    self.stackView.frame = self.bounds;
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

@end