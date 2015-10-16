#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BPStackView.h"
#import "BPCameraSessionManager.h"
#import "BPProductCardView.h"


@class BPScanCodeViewController;
@class BPProductResult;


@protocol BPScanCodeViewControllerDelegate <NSObject>

@end


@interface BPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, BPStackViewDelegate, BPCameraSessionManagerDelegate, BPProductCardViewDelegate>

@property(nonatomic, weak) id <BPScanCodeViewControllerDelegate> delegate;

@end