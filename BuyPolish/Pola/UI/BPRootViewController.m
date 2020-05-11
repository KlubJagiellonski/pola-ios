#import "BPRootViewController.h"
#import "BPScanCodeViewController.h"

@import Objection;

@implementation BPRootViewController

- (id)init {
    self = [super init];
    if (self) {
        self.navigationBarHidden = YES;

        JSObjectionInjector *injector = [JSObjection defaultInjector];
        BPScanCodeViewController *scanCodeViewController = injector [[BPScanCodeViewController class]];
        self.viewControllers = @[scanCodeViewController];
    }

    return self;
}

- (void)showScanCodeView {
    BPScanCodeViewController *scanCodeViewController = (BPScanCodeViewController *)self.viewControllers.firstObject;
    [scanCodeViewController showScanCodeView];
}

- (void)showWriteCodeView {
    BPScanCodeViewController *scanCodeViewController = (BPScanCodeViewController *)self.viewControllers.firstObject;
    [scanCodeViewController showWriteCodeView];
}

@end
