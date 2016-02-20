#import <Foundation/Foundation.h>

@class BPStackView;


@interface BPScanCodeView : UIView

@property(nonatomic, readonly) BPStackView *stackView;

@property(nonatomic) AVCaptureVideoPreviewLayer *videoLayer;

@property(nonatomic, readonly) UIButton *menuButton;
@property(nonatomic, readonly) UIButton *flashButton;

- (void)setInfoTextVisible:(BOOL)visible;

- (void)setMenuButtonVisible:(BOOL)visible animation:(BOOL)animation;
@end