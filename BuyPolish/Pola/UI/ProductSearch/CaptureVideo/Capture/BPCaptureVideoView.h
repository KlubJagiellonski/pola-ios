#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@class BPCaptureVideoView;

@protocol BPCaptureVideoViewDelegate <NSObject>
- (void)captureVideoViewDidTapClose:(BPCaptureVideoView *)view;
- (void)captureVideoViewDidTapStart:(BPCaptureVideoView *)view;
@end

@interface BPCaptureVideoView : UIView

@property (weak, nonatomic) id<BPCaptureVideoViewDelegate> delegate;

@property (nonatomic) AVCaptureVideoPreviewLayer *videoLayer;

@property (nonatomic, readonly) UILabel *productLabel;
@property (nonatomic, readonly) UILabel *timeLabel;
@property (nonatomic, readonly) UIButton *closeButton;
@property (nonatomic, readonly) UIButton *startButton;

- (instancetype)initWithFrame:(CGRect)frame
             productLabelText:(NSString *)productLabelText
          initialTimerSeconds:(int)initialTimerSeconds;
- (void)updateProductAndTimeLabelsWithCapturing:(BOOL)capturing;
- (void)setTimeLabelSec:(int)seconds;

@end
