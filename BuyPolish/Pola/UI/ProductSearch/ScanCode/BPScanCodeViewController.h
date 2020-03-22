#import <AVFoundation/AVFoundation.h>
#import <Foundation/Foundation.h>
#import <Pola-Swift.h>

@interface BPScanCodeViewController
    : UIViewController <AVCaptureMetadataOutputObjectsDelegate, BPKeyboardViewControllerDelegate>
- (void)showScanCodeView;
- (void)showWriteCodeView;
@end
