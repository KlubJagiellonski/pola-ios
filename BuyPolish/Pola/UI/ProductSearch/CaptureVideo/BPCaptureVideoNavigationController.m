#import "BPCaptureVideoNavigationController.h"
#import "BPCaptureVideoInstructionViewController.h"

@interface BPCaptureVideoNavigationController ()
@property(nonatomic, readonly) BPScanResult *scanResult;
@end

@implementation BPCaptureVideoNavigationController

- (instancetype)initWithScanResult:(BPScanResult*)scanResult {
    self = [super init];
    if (self) {
        _scanResult = scanResult;
        
        BPCaptureVideoInstructionViewController *instructionViewController = [[BPCaptureVideoInstructionViewController alloc] initWithScanResult:scanResult];
        instructionViewController.delegate = self;
        self.viewControllers = @[instructionViewController];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES];
}

#pragma mark - Actions

-(void)showCaptureVideoViewController {
    // TODO: implement
}

-(void)popCaptureVideoViewController {
    // TODO: implement
}

#pragma mark - BPCaptureVideoNavigationControllerDelegate

- (void)captureVideoInstructionViewControllerWantsCaptureVideo:(BPCaptureVideoInstructionViewController *) viewController {
    [self showCaptureVideoViewController];
}

- (void)captureVideoInstructionViewControllerWantsDismiss:(BPCaptureVideoInstructionViewController *) viewController {
    [self.captureDelegate captureVideoNavigationControllerWantsDismiss:self];
}

@end
