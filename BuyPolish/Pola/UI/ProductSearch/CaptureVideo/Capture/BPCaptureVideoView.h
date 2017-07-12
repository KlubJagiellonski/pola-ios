#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@class BPCaptureVideoView;

@protocol BPCaptureVideoViewDelegate <NSObject>
- (void)captureVideoViewDidTapClose:(BPCaptureVideoView *)view;
- (void)captureVideoViewDidTapStart:(BPCaptureVideoView *)view;
@end

@interface BPCaptureVideoView : UIView

@property(weak, nonatomic) id <BPCaptureVideoViewDelegate> delegate;

@property(nonatomic) AVCaptureVideoPreviewLayer *videoLayer;

@property(nonatomic, readonly) UILabel *timeLabel;
@property(nonatomic, readonly) UIButton *closeButton;
@property(nonatomic, readonly) UIButton *startButton;

- (instancetype)initWithFrame:(CGRect)frame initialTimerSec:(int)initialTimerSec;
- (void)setTimeLabelSec:(int)seconds;

@end
