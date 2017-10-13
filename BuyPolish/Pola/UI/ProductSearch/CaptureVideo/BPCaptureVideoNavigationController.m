#import <Objection/Objection.h>
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
        
        JSObjectionInjector *injector = [JSObjection defaultInjector];
        BPCaptureVideoInstructionViewController *instructionViewController = [injector getObject:[BPCaptureVideoInstructionViewController class] argumentList:@[scanResult]];
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
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    BPCaptureVideoViewController *captureVideoController = [injector getObject:[BPCaptureVideoViewController class] argumentList:@[self.scanResult]];
    captureVideoController.delegate = self;
    [self pushViewController:captureVideoController animated:YES];
}

#pragma mark - BPCaptureVideoInstructionViewControllerDelegate

- (void)captureVideoInstructionViewControllerWantsCaptureVideo:(BPCaptureVideoInstructionViewController *)viewController {
    [self showCaptureVideoViewController];
}

- (void)captureVideoInstructionViewControllerWantsDismiss:(BPCaptureVideoInstructionViewController *)viewController {
    [self.captureDelegate captureVideoNavigationController:self wantsDismissWithSuccess:false];
}

#pragma mark - BPCaptureVideoViewControllerDelegate

- (void)captureVideoViewController:(BPCaptureVideoViewController *)viewController wantsDismissWithSuccess:(BOOL)success {
    [self.captureDelegate captureVideoNavigationController:self wantsDismissWithSuccess:success];
}

@end
