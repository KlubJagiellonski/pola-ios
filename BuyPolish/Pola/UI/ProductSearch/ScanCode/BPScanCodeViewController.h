#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BPStackView.h"
#import "BPCameraSessionManager.h"
#import "BPCompanyCardView.h"
#import "BPReportProblemViewController.h"
#import "BPAboutNavigationController.h"


@class BPScanCodeViewController;
@class BPScanResult;


@protocol BPScanCodeViewControllerDelegate <NSObject>

@end


@interface BPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, BPStackViewDelegate, BPCameraSessionManagerDelegate, BPCompanyCardViewDelegate, BPReportProblemViewControllerDelegate, BPInfoNavigationControllerDelegate>

@property(weak, nonatomic) id <BPScanCodeViewControllerDelegate> delegate;

@end