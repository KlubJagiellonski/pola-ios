#import <Foundation/Foundation.h>
#import "BPCaptureVideoInstructionViewController.h"
#import "BPCaptureVideoViewController.h"
#import "BPScanResult.h"

@class BPCaptureVideoNavigationController;

@protocol BPCaptureVideoNavigationControllerDelegate <NSObject>
- (void)captureVideoNavigationControllerWantsDismiss:(BPCaptureVideoNavigationController *)viewController;
- (void)captureVideoNavigationController:(BPCaptureVideoNavigationController *)viewController didCaptureImages:(NSArray<UIImage*> *)images;
@end

@interface BPCaptureVideoNavigationController : UINavigationController <BPCaptureVideoInstructionViewControllerDelegate, BPCaptureVideoViewControllerDelegate>

@property(weak, nonatomic) id <BPCaptureVideoNavigationControllerDelegate> captureDelegate;

- (instancetype)initWithScanResult:(BPScanResult*)scanResult;

@end
