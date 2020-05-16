#import "BPCaptureVideoInstructionViewController.h"
#import "BPCaptureVideoViewController.h"
#import "BPCapturedImagesData.h"
#import "BPScanResult.h"
#import <Foundation/Foundation.h>

@class BPCaptureVideoNavigationController;

@protocol BPCaptureVideoNavigationControllerDelegate <NSObject>
- (void)captureVideoNavigationController:(BPCaptureVideoNavigationController *)controller
                 wantsDismissWithSuccess:(BOOL)success;
@end

@interface BPCaptureVideoNavigationController
    : UINavigationController <BPCaptureVideoInstructionViewControllerDelegate, BPCaptureVideoViewControllerDelegate>

@property (weak, nonatomic) id<BPCaptureVideoNavigationControllerDelegate> captureDelegate;

- (instancetype)initWithScanResult:(BPScanResult *)scanResult;

@end
