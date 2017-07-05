#import <Foundation/Foundation.h>
#import "BPCaptureVideoInstructionView.h"

@class BPCaptureVideoInstructionViewController;

@protocol BPCaptureVideoInstructionViewControllerDelegate <NSObject>

- (void)captureVideoInstructionViewControllerWantsCaptureVideo:(BPCaptureVideoInstructionViewController *) viewController;
@end

@interface BPCaptureVideoInstructionViewController : UIViewController <BPCaptureVideoInstructionViewDelegate>

@property(weak, nonatomic) id <BPCaptureVideoInstructionViewControllerDelegate> delegate;

@end
