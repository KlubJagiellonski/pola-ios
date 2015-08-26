#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@class BPScanCodeViewController;
@class BPProduct;


@protocol BPScanCodeViewControllerDelegate <NSObject>

- (void)scanCode:(BPScanCodeViewController *)viewController requestsProductInfo:(BPProduct *)product;

@end


@interface BPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property(nonatomic, weak) id <BPScanCodeViewControllerDelegate> delegate;

@end