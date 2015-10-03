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


- (void)addVideoPreviewLayer:(AVCaptureVideoPreviewLayer *)layer {
    [layer setFrame:self.layer.bounds];

    [self.layer addSublayer:layer];

    [self bringSubviewToFront:self.stackView];
}
@end