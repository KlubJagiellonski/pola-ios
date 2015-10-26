#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BPStackView.h"
#import "BPCameraSessionManager.h"
#import "BPProductCardView.h"
#import "BPReportProblemViewController.h"
#import "BPAboutNavigationController.h"


@class BPScanCodeViewController;
@class BPProductResult;


@protocol BPScanCodeViewControllerDelegate <NSObject>

@end


@interface BPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, BPStackViewDelegate, BPCameraSessionManagerDelegate, BPProductCardViewDelegate, BPReportProblemViewControllerDelegate, BPInfoNavigationControllerDelegate>

@property(nonatomic, weak) id <BPScanCodeViewControllerDelegate> delegate;

@end