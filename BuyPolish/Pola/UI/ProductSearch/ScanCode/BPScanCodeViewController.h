#import "BPAboutNavigationController.h"
#import "BPCameraSessionManager.h"
#import "BPCaptureVideoNavigationController.h"
#import "BPKeyboardViewController.h"
#import "BPReportProblemViewController.h"
#import "BPStackView.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>

@class BPScanCodeViewController;
@class BPScanResult;

@interface BPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate,
                                                        UIAlertViewDelegate,
                                                        BPStackViewDelegate,
                                                        BPCameraSessionManagerDelegate,
                                                        BPInfoNavigationControllerDelegate,
                                                        BPKeyboardViewControllerDelegate>
- (void)showScanCodeView;
- (void)showWriteCodeView;
@end
