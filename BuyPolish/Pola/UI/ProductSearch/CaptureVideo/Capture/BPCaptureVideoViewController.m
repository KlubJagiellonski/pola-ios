#import <Objection/Objection.h>
#import "BPCaptureVideoViewController.h"
#import "BPCapturedImageManager.h"
#import "UIImage+Scaling.h"
#import <sys/utsname.h>

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
    self.view = [[BPCaptureVideoView alloc] initWithFrame:CGRectZero initialTimerSec:INITIAL_TIMER_SEC];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.castView.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.castView.videoLayer = self.videoManager.videoPreviewLayer;
    [self.videoManager startCameraPreview];
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
    
    [self captureImageAndFinishIfNeeded];
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
    [self.castView.startButton setHidden:NO];
}

- (void)captureImageAndFinishIfNeeded {
    [self.videoManager captureImageWithCompletion:^(UIImage *originalImage, NSError *error) {
        if (error == nil) {
            
            UIImage *scaledImage = [self scaledImage:originalImage withMaxSide:self.scanResult.maxPicSize.doubleValue];
            NSData *imageData = UIImageJPEGRepresentation(scaledImage, 0.5);
            [self.imageManager saveImageData:imageData captureSessionTimestamp:self.sessionTimestamp index:self.savedImagesCount];
            
            self.savedImagesCount += 1;
            
            if (self.savedImagesCount == INITIAL_TIMER_SEC) {
                [self handleScaledLastImage:scaledImage originalImage:originalImage];
            }
            
        } else {
            NSLog(@"error while capturing image: %@", error);
        }
    }];
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
                                                                                    deviceName:[self deviceName]];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"CaptureVideo.SendConfirmation.Title", nil) message:NSLocalizedString(@"CaptureVideo.SendConfirmation.Message", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CaptureVideo.SendConfirmation.Cancel", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self reset];
    }];
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"CaptureVideo.SendConfirmation.Send", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.delegate captureVideoViewController:self didFinishCapturingWithSessionTimestamp:self.sessionTimestamp imagesData:capturedImagesData];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sendAction];
    
    [self presentViewController:alert animated:true completion:nil];
}

- (void)invalidateTimer {
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark - BPCaptureVideoViewDelegate

- (void)captureVideoViewDidTapBack:(BPCaptureVideoView *)view {
    [self.delegate captureVideoViewControllerWantsBack:self];
}

- (void)captureVideoViewDidTapClose:(BPCaptureVideoView *)view {
    [self.delegate captureVideoViewControllerWantsDismiss:self];
}

- (void)captureVideoViewDidTapStart:(BPCaptureVideoView *)view {
    [self.castView.startButton setHidden:YES];
    self.sessionTimestamp = [[NSDate date] timeIntervalSince1970];
    [self captureImageAndFinishIfNeeded];
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - Helpers

- (BPCaptureVideoView *)castView {
    return (BPCaptureVideoView *) self.view;
}

- (UIImage *)scaledImage:(UIImage*)originalImage withMaxSide:(double)maxSide {
    CGImageRef cgImage = originalImage.CGImage;
    if ( CGImageGetHeight(cgImage) > CGImageGetWidth(cgImage) ) {
        return [originalImage scaledToHeight:maxSide];
    } else {
        return [originalImage scaledToWidth:maxSide];
    }
}

- (NSString*)deviceName {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

        
@end
