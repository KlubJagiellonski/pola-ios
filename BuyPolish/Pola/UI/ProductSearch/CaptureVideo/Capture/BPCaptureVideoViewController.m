#import <Objection/Objection.h>
#import "BPCaptureVideoViewController.h"

const int INITIAL_TIMER_SEC = 6;

@interface BPCaptureVideoViewController ()

@property(nonatomic) BPScanResult *scanResult;
@property(nonatomic, readonly) BPCameraSessionManager *cameraSessionManager;
@property(nonatomic) int timerSeconds;
@property(nonatomic) NSTimer *timer;

@end

@implementation BPCaptureVideoViewController

objection_requires_sel(@selector(cameraSessionManager))
objection_initializer_sel(@selector(initWithScanResult:))

- (instancetype)initWithScanResult:(BPScanResult*)scanResult {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _scanResult = scanResult;
        _timerSeconds = INITIAL_TIMER_SEC;
    }
    
    return self;
}

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.castView.videoLayer = self.cameraSessionManager.videoPreviewLayer;
    [self.cameraSessionManager start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.cameraSessionManager stop];
    [self invalidateTimer];
}

- (void)updateTimerSeconds {
    self.timerSeconds -= 1;
    [self updateTimerLabelWithSec:self.timerSeconds];
    if (self.timerSeconds <= 0) {
        [self invalidateTimer];
        [self.delegate captureVideoViewControllerWantsDismiss:self];
    }
}

- (void)updateTimerLabelWithSec:(int)seconds {
    [self.castView setTimeLabelSec:seconds];
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
    self.timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateTimerSeconds) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    // start capturing
}


#pragma mark - Helpers

- (BPCaptureVideoView *)castView {
    return (BPCaptureVideoView *) self.view;
}

@end
