#import <Foundation/Foundation.h>

@class BPCaptureVideoInstructionView;

@protocol BPCaptureVideoInstructionViewDelegate <NSObject>

- (void)captureVideoInstructionViewDidTapCapture:(BPCaptureVideoInstructionView *) view;
@end

@interface BPCaptureVideoInstructionView : UIView


@property(weak, nonatomic) id <BPCaptureVideoInstructionViewDelegate> delegate;
@property(nonatomic, readonly) UILabel *testLabel;

@end
