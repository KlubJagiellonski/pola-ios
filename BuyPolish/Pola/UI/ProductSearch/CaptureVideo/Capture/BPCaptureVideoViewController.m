#import <Objection/Objection.h>
#import "BPCaptureVideoViewController.h"
#import "BPCapturedImageManager.h"
#import "UIImage+Scaling.h"
#import "BPWeakTimerTarget.h"
#import "BPDeviceHelper.h"

const int INITIAL_TIMER_SEC = 6;

@interface BPCaptureVideoViewController ()

@property(nonatomic) BPScanResult *scanResult;
@property(nonatomic) int timerSeconds;
@property(nonatomic) NSTimer *timer;
@property(nonatomic, readonly) BPCaptureVideoManager *videoManager;
@property(nonatomic) int sessionTimestamp;      // seconds since 1970
@property(nonatomic, readonly) BPCapturedImageManager *imageManager;
@property(nonatomic) int savedImagesCount;

@end

@implementation BPCaptureVideoViewController

objection_requires_sel(@selector(videoManager), @selector(imageManager))
objection_initializer_sel(@selector(initWithScanResult:))

- (instancetype)initWithScanResult:(BPScanResult*)scanResult {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _scanResult = scanResult;
        _timerSeconds = INITIAL_TIMER_SEC;
        _savedImagesCount = 0;
        _sessionTimestamp = 0;
    }
    
    return self;
}

- (void)loadView {
    self.view = [[BPCaptureVideoView alloc] initWithFrame:CGRectZero productLabelText:self.scanResult.askForPicsProduct initialTimerSeconds:INITIAL_TIMER_SEC];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.castView.delegate = self;
    self.videoManager.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.videoManager startCameraPreview];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.castView.videoLayer = self.videoManager.videoPreviewLayer;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Camera Privacy Title", nil)
                                                            message:NSLocalizedString(@"Camera Privacy Capture Video Description", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"Settings", nil), nil];
        [alertView show];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.videoManager stopCameraPreview];
    [self reset];
}

- (void)timerAction {
    self.timerSeconds -= 1;
    [self.castView setTimeLabelSec:self.timerSeconds];
    if (self.timerSeconds == 0) {
        [self invalidateTimer];
        return;
    }
    
    [self captureImage];
}

- (void)reset {
    [self invalidateTimer];
    if ( (self.sessionTimestamp != 0) && (self.savedImagesCount != INITIAL_TIMER_SEC) ) {
        [self.imageManager removeImagesDataForCaptureSessionTimestamp:self.sessionTimestamp imageCount:self.savedImagesCount];
    }
    self.sessionTimestamp = 0;
    self.savedImagesCount = 0;
    self.timerSeconds = INITIAL_TIMER_SEC;
    [self.castView setTimeLabelSec:INITIAL_TIMER_SEC];
    [self.castView updateProductAndTimeLabelsWithCapturing:NO];
    [self.castView.startButton setHidden:NO];
}

- (void)captureImage {
    [self.videoManager requestCaptureImage];
}

- (void)handleScaledLastImage:(UIImage *)scaledImage originalImage:(UIImage *)originalImage {
    BPCapturedImagesData *capturedImagesData = [[BPCapturedImagesData alloc] initWithProductID:self.scanResult.productId
                                                                                    filesCount:[[NSNumber alloc] initWithInt: self.savedImagesCount]
                                                                                 fileExtension:@"jpg"
                                                                                      mimeType:@"image/jpeg"
                                                                                 originalWidth:[[NSNumber alloc] initWithInt: [originalImage widthInPixels]]
                                                                                originalHeight:[[NSNumber alloc] initWithInt: [originalImage heightInPixels]]
                                                                                         width:[[NSNumber alloc] initWithInt: [scaledImage widthInPixels]]
                                                                                        height:[[NSNumber alloc] initWithInt: [scaledImage heightInPixels]]
                                                                                    deviceName:[BPDeviceHelper deviceName]];
    
    [self.delegate captureVideoViewController:self didFinishCapturingWithSessionTimestamp:self.sessionTimestamp imagesData:capturedImagesData];
}

- (void)invalidateTimer {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - BPCaptureVideoViewDelegate

- (void)captureVideoViewDidTapClose:(BPCaptureVideoView *)view {
    [self.delegate captureVideoViewControllerWantsDismiss:self];
}

- (void)captureVideoViewDidTapStart:(BPCaptureVideoView *)view {
    [self.castView.startButton setHidden:YES];
    [self.castView updateProductAndTimeLabelsWithCapturing:YES];
    self.sessionTimestamp = [[NSDate date] timeIntervalSince1970];
    [self captureImage];
    BPWeakTimerTarget *target = [[BPWeakTimerTarget alloc] initWithTarget:self selector:@selector(timerAction)];
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:target selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - BPCaptureVideoManagerDelegate

- (void)captureVideoManager:(BPCaptureVideoManager *)captureManager didCaptureImage:(UIImage *)originalImage {
    UIImage *scaledImage = [self scaledImage:originalImage withMaxSide:self.scanResult.maxPicSize.doubleValue];
    NSData *imageData = UIImageJPEGRepresentation(scaledImage, 0.5);
    [self.imageManager saveImageData:imageData captureSessionTimestamp:self.sessionTimestamp index:self.savedImagesCount];
    
    self.savedImagesCount += 1;
    
    if (self.savedImagesCount == INITIAL_TIMER_SEC) {
        [self handleScaledLastImage:scaledImage originalImage:originalImage];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex != buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - Helpers

- (BPCaptureVideoView *)castView {
    return (BPCaptureVideoView *) self.view;
}

- (UIImage *)scaledImage:(UIImage*)originalImage withMaxSide:(double)maxSide {
    if ( originalImage.size.height > originalImage.size.width ) {
        return [originalImage scaledToHeight:maxSide];
    } else {
        return [originalImage scaledToWidth:maxSide];
    }
}

@end
