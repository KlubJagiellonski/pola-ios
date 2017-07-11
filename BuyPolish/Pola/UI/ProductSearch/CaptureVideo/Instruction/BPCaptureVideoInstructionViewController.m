#import <Objection/Objection.h>
#import "BPCaptureVideoInstructionViewController.h"
#import "BPCaptureVideoInstructionView.h"

@interface BPCaptureVideoInstructionViewController ()

@property(nonatomic) BPScanResult *scanResult;

@end

@implementation BPCaptureVideoInstructionViewController

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
    
    NSURL *instructionVideoURL = [[NSURL alloc]initWithString:@"https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"];
    [self.castView playVideoWithURL:instructionVideoURL];
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
