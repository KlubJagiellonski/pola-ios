#import "BPAboutNavigationController.h"
#import "BPCameraSessionManager.h"
#import "BPCaptureVideoNavigationController.h"
#import "BPKeyboardViewController.h"
#import "BPReportProblemViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <Pola-Swift.h>

@interface BPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate,
                                                        UIAlertViewDelegate,
                                                        CardStackViewDelegate,
                                                        BPCameraSessionManagerDelegate,
                                                        BPInfoNavigationControllerDelegate,
                                                        BPKeyboardViewControllerDelegate>
- (void)showScanCodeView;
- (void)showWriteCodeView;
@end
