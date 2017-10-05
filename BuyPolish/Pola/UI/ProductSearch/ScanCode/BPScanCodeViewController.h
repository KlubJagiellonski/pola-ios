#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BPStackView.h"
#import "BPCameraSessionManager.h"
#import "BPCompanyCardView.h"
#import "BPReportProblemViewController.h"
#import "BPAboutNavigationController.h"
#import "BPKeyboardViewController.h"
#import "BPCaptureVideoNavigationController.h"
#import "BPImageRecognitionManager.h"


@class BPScanCodeViewController;
@class BPScanResult;

@interface BPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate, BPStackViewDelegate, BPCameraSessionManagerDelegate, BPCompanyCardViewDelegate, BPCaptureVideoNavigationControllerDelegate, BPReportProblemViewControllerDelegate, BPInfoNavigationControllerDelegate, BPKeyboardViewControllerDelegate, BPImageRecognitionManagerDelegate>
- (void)showScanCodeView;
- (void)showWriteCodeView;
@end
