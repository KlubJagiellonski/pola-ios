#import "BPCaptureVideoNavigationController.h"
#import "BPCaptureVideoInstructionViewController.h"

@interface BPCaptureVideoNavigationController ()

@end

@implementation BPCaptureVideoNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        BPCaptureVideoInstructionViewController *instructionViewController = [BPCaptureVideoInstructionViewController new];
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

@end
