#import "BPCaptureVideoInstructionViewController.h"
#import "BPCaptureVideoInstructionView.h"

@interface BPCaptureVideoInstructionViewController ()

//properties

@end

@implementation BPCaptureVideoInstructionViewController

- (void)loadView {
    self.view = [[BPCaptureVideoInstructionView alloc] initWithFrame:CGRectZero];
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

- (void)captureVideoInstructionViewDidTapCapture:(BPCaptureVideoInstructionView *) view {
    
}


#pragma mark - Helpers

- (BPCaptureVideoInstructionView *)castView {
    return (BPCaptureVideoInstructionView *) self.view;
}

@end
