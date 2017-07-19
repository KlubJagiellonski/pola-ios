#import <Foundation/Foundation.h>
#import "BPCaptureVideoView.h"
#import "BPScanResult.h"
#import "BPCaptureVideoManager.h"
#import "BPCapturedImagesData.h"

@class BPCaptureVideoViewController;

@protocol BPCaptureVideoViewControllerDelegate <NSObject>

- (void)captureVideoViewController:(BPCaptureVideoViewController *)viewController didFinishCapturingWithSessionTimestamp:(int)timestamp imagesData:(BPCapturedImagesData *)imagesData;
- (void)captureVideoViewControllerWantsDismiss:(BPCaptureVideoViewController *)viewController;

@end

@interface BPCaptureVideoViewController : UIViewController <BPCaptureVideoViewDelegate>

@property(weak, nonatomic) id <BPCaptureVideoViewControllerDelegate> delegate;

- (instancetype)initWithScanResult:(BPScanResult*)scanResult;

@end
