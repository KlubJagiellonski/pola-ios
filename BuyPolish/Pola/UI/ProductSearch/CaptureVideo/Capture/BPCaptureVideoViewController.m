#import <Objection/Objection.h>
#import "BPCaptureVideoViewController.h"

const int INITIAL_TIMER_SEC = 6;

@interface BPCaptureVideoViewController ()

@property(nonatomic) BPScanResult *scanResult;
@property(nonatomic) int timerSeconds;
@property(nonatomic) NSTimer *timer;
@property(nonatomic, readonly) BPCaptureVideoManager *captureVideoManager;
@property(nonatomic, readonly) NSMutableArray<UIImage*> *capturedImages;

@end

@implementation BPCaptureVideoViewController

objection_requires_sel(@selector(captureVideoManager))
objection_initializer_sel(@selector(initWithScanResult:))

- (instancetype)initWithScanResult:(BPScanResult*)scanResult {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _scanResult = scanResult;
        _timerSeconds = INITIAL_TIMER_SEC;
        _capturedImages = [[NSMutableArray<UIImage*> alloc] init];
    }
    
    return self;
}

// TODO throw exception on calling default init

- (void)loadView {
    self.view = [[BPCaptureVideoView alloc] initWithFrame:CGRectZero initialTimerSec:INITIAL_TIMER_SEC];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.castView.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.castView.videoLayer = self.captureVideoManager.videoPreviewLayer;
    [self.captureVideoManager startCameraPreview];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.captureVideoManager stopCameraPreview];
    [self invalidateTimer];
}

- (void)timerAction {
    self.timerSeconds -= 1;
    [self.castView setTimeLabelSec:self.timerSeconds];
    if (self.timerSeconds == 0) {
        [self invalidateTimer];
    }
    
    [self captureImageAndFinishIfNeeded];
}

- (void)captureImageAndFinishIfNeeded {
    [self.captureVideoManager captureImageWithCompletion:^(UIImage *image, NSError *error) {
        if (error == nil) {
            
            [self.capturedImages addObject:image];
            
            if (self.capturedImages.count == INITIAL_TIMER_SEC) {
                [self.delegate captureVideoViewController:self didFinishCapturingImages:self.capturedImages];
            }
            
        } else {
            NSLog(@"error while capturing image: %@", error);
            // TODO: present error alert
        }
    }];
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
    [self captureImageAndFinishIfNeeded];
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - Helpers

- (BPCaptureVideoView *)castView {
    return (BPCaptureVideoView *) self.view;
}

@end
