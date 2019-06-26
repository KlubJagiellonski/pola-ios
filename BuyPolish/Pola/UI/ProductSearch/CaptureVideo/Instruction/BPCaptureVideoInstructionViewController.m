#import "BPCaptureVideoInstructionViewController.h"
#import "BPCaptureVideoInstructionView.h"

@import Objection;

@interface BPCaptureVideoInstructionViewController ()

@property(nonatomic) BPScanResult *scanResult;

@end

@implementation BPCaptureVideoInstructionViewController

objection_initializer_sel(@selector(initWithScanResult:))

- (instancetype)initWithScanResult:(BPScanResult*)scanResult {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _scanResult = scanResult;
    }
    
    return self;
}

- (void)loadView {
    self.view = [[BPCaptureVideoInstructionView alloc] initWithFrame:CGRectZero title:self.scanResult.askForPicsTitle instruction: self.scanResult.askForPicsText captureButtonText: self.scanResult.askForPicsButtonStart];
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
    
    NSString *videoFileName = @"capture_video_instruction";
    NSString *videoFileExt = @"mov";
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:videoFileName ofType:videoFileExt];
    if (videoPath != nil) {
        NSURL *videoUrl = [NSURL fileURLWithPath:videoPath];
        [self.castView playVideoWithURL:videoUrl];
        
    } else {
        BPLog(@"Failed to play instruction video, no file at bundle: %@.%@", videoFileName, videoFileExt);
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.castView stopVideo];
}

#pragma mark - BPCaptureVideoInstructionViewDelegate

- (void)captureVideoInstructionViewDidTapClose:(BPCaptureVideoInstructionView *)view {
    [self.delegate captureVideoInstructionViewControllerWantsDismiss:self];
}

- (void)captureVideoInstructionViewDidTapCapture:(BPCaptureVideoInstructionView *)view {
    [self.delegate captureVideoInstructionViewControllerWantsCaptureVideo:self];
}

#pragma mark - Helpers

- (BPCaptureVideoInstructionView *)castView {
    return (BPCaptureVideoInstructionView *) self.view;
}

@end
