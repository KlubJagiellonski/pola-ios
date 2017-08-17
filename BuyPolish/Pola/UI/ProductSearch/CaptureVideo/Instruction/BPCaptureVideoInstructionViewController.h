#import <Foundation/Foundation.h>
#import "BPCaptureVideoInstructionView.h"
#import "BPScanResult.h"

@class BPCaptureVideoInstructionViewController;

@protocol BPCaptureVideoInstructionViewControllerDelegate <NSObject>

- (void)captureVideoInstructionViewControllerWantsCaptureVideo:(BPCaptureVideoInstructionViewController *) viewController;
- (void)captureVideoInstructionViewControllerWantsDismiss:(BPCaptureVideoInstructionViewController *) viewController;
@end

@interface BPCaptureVideoInstructionViewController : UIViewController <BPCaptureVideoInstructionViewDelegate>

@property(weak, nonatomic) id <BPCaptureVideoInstructionViewControllerDelegate> delegate;

- (instancetype)initWithScanResult:(BPScanResult*)scanResult;

@end
