#import <Foundation/Foundation.h>

@class BPStackView;


@interface BPScanCodeView : UIView

@property(nonatomic, readonly) BPStackView *stackView;

- (void)addVideoPreviewLayer:(AVCaptureVideoPreviewLayer *)layer;

@end