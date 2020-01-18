#import "BPCameraSessionManager.h"
#import "BPCaptureVideoNavigationController.h"
#import "BPKeyboardViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <Pola-Swift.h>

@interface BPScanCodeViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate,
                                                        UIAlertViewDelegate,
                                                        BPCameraSessionManagerDelegate,
                                                        BPKeyboardViewControllerDelegate>
- (void)showScanCodeView;
- (void)showWriteCodeView;
@end
