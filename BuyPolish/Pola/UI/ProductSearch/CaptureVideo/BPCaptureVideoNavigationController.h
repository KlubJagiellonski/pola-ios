#import "BPCaptureVideoInstructionViewController.h"
#import "BPCaptureVideoViewController.h"
#import "BPCapturedImagesData.h"
#import "BPScanResult.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BPCaptureVideoNavigationController;

@protocol BPCaptureVideoNavigationControllerDelegate <NSObject>
- (void)captureVideoNavigationController:(BPCaptureVideoNavigationController *)controller
                 wantsDismissWithSuccess:(BOOL)success;
@end

@interface BPCaptureVideoNavigationController
    : UINavigationController <BPCaptureVideoInstructionViewControllerDelegate, BPCaptureVideoViewControllerDelegate>

@property (weak, nonatomic, nullable) id<BPCaptureVideoNavigationControllerDelegate> captureDelegate;

- (instancetype)initWithScanResult:(BPScanResult *)scanResult;

@end

NS_ASSUME_NONNULL_END
