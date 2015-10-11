#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BPStackView.h"


@class BPScanCodeViewController;
@class BPProductResult;


@protocol BPScanCodeViewControllerDelegate <NSObject>

@end


@interface BPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, BPStackViewDelegate>

@property(nonatomic, weak) id <BPScanCodeViewControllerDelegate> delegate;

@end