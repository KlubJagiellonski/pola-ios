#import <Foundation/Foundation.h>

@class BPCaptureVideoInstructionView;

@protocol BPCaptureVideoInstructionViewDelegate <NSObject>
- (void)captureVideoInstructionViewDidTapCapture:(BPCaptureVideoInstructionView *)view;
- (void)captureVideoInstructionViewDidTapClose:(BPCaptureVideoInstructionView *)view;
@end

@interface BPCaptureVideoInstructionView : UIView

@property(weak, nonatomic) id <BPCaptureVideoInstructionViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title instruction:(NSString*)instruction captureButtonText:(NSString*)captureButtonText;

-(void)playVideoWithURL:(NSURL*)URL;

@end
