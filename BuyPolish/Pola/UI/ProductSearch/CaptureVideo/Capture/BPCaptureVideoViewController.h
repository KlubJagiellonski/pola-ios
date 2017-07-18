#import <Foundation/Foundation.h>
#import "BPCaptureVideoView.h"
#import "BPScanResult.h"
#import "BPCaptureVideoManager.h"

@class BPCaptureVideoViewController;

@protocol BPCaptureVideoViewControllerDelegate <NSObject>

- (void)captureVideoViewController:(BPCaptureVideoViewController *)viewController didFinishCapturingImages:(NSArray<UIImage*> *)images;
- (void)captureVideoViewControllerWantsDismiss:(BPCaptureVideoViewController *)viewController;

@end

@interface BPCaptureVideoViewController : UIViewController <BPCaptureVideoViewDelegate>

@property(weak, nonatomic) id <BPCaptureVideoViewControllerDelegate> delegate;

- (instancetype)initWithScanResult:(BPScanResult*)scanResult;

@end
