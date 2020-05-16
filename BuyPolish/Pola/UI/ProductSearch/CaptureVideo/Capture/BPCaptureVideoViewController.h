#import "BPCaptureVideoManager.h"
#import "BPCaptureVideoView.h"
#import "BPCapturedImagesData.h"
#import "BPScanResult.h"
#import <Foundation/Foundation.h>

@class BPCaptureVideoViewController;

@protocol BPCaptureVideoViewControllerDelegate <NSObject>

- (void)captureVideoViewController:(BPCaptureVideoViewController *)viewController wantsDismissWithSuccess:(BOOL)success;

@end

@interface BPCaptureVideoViewController
    : UIViewController <BPCaptureVideoViewDelegate, BPCaptureVideoManagerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) id<BPCaptureVideoViewControllerDelegate> delegate;

- (instancetype)initWithScanResult:(BPScanResult *)scanResult;

@end
