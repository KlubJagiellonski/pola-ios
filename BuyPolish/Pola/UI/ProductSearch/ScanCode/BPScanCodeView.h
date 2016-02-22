#import <Foundation/Foundation.h>

@class BPStackView;


@interface BPScanCodeView : UIView

@property(nonatomic, readonly) BPStackView *stackView;

@property(nonatomic) AVCaptureVideoPreviewLayer *videoLayer;

@property(nonatomic, readonly) UIButton *menuButton;
@property(nonatomic, readonly) UIButton *flashButton;

@property(nonatomic, getter=isFlashlightButtonHidden) BOOL flashlightButtonHidden;

- (void)setInfoTextVisible:(BOOL)visible;

- (void)setMenuButtonVisible:(BOOL)visible animation:(BOOL)animation;
@end