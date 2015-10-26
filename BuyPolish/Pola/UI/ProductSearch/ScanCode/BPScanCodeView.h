#import <Foundation/Foundation.h>

@class BPStackView;


@interface BPScanCodeView : UIView

@property(nonatomic, readonly) BPStackView *stackView;

@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoLayer;

@property(nonatomic, readonly) UIButton *menuButton;

- (void)setInfoTextVisible:(BOOL)visible;
@end