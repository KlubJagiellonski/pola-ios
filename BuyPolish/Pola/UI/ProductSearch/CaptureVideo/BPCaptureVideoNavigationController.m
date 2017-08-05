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
    [self.captureDelegate captureVideoNavigationControllerWantsDismiss:self];
}

#pragma mark - BPCaptureVideoViewControllerDelegate

- (void)captureVideoViewControllerWantsDismiss:(BPCaptureVideoViewController *)viewController {
    [self.captureDelegate captureVideoNavigationControllerWantsDismiss:self];
}

- (void)captureVideoViewControllerWantsBack:(BPCaptureVideoViewController *)viewController {
    [self popViewControllerAnimated:true];
}

- (void)captureVideoViewController:(BPCaptureVideoViewController *)viewController didFinishCapturingWithSessionTimestamp:(int)timestamp imagesData:(BPCapturedImagesData *)imagesData {
    [self.captureDelegate captureVideoNavigationController:self didCaptureImagesWithTimestamp:timestamp imagesData:imagesData];
    [self.captureDelegate captureVideoNavigationControllerWantsDismiss:self];
}

@end
