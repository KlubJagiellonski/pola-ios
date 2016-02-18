#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BPStackView.h"
#import "BPCameraSessionManager.h"
#import "BPCompanyCardView.h"
#import "BPReportProblemViewController.h"
#import "BPAboutNavigationController.h"


@class BPScanCodeViewController;
@class BPScanResult;

@interface BPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, BPStackViewDelegate, BPCameraSessionManagerDelegate, BPCompanyCardViewDelegate, BPReportProblemViewControllerDelegate, BPInfoNavigationControllerDelegate>

@end