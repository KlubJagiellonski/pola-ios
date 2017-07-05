#import <Foundation/Foundation.h>
#import "BPCaptureVideoInstructionViewController.h"
@class BPCaptureVideoNavigationController;

@protocol BPCaptureVideoNavigationControllerDelegate <NSObject>
- (void)captureVideoWantsDismiss:(BPCaptureVideoNavigationController *)viewController;
@end

@interface BPCaptureVideoNavigationController : UINavigationController <BPCaptureVideoInstructionViewControllerDelegate>

@property(weak, nonatomic) id <BPCaptureVideoNavigationControllerDelegate> captureDelegate;

@end
