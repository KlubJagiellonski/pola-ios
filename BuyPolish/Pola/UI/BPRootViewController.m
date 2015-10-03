#import <Objection/JSObjection.h>
#import "BPRootViewController.h"
#import "BPScanCodeViewController.h"


@implementation BPRootViewController

- (id)init {
    self = [super init];
    if (self) {
        self.navigationBarHidden = YES;

        JSObjectionInjector *injector = [JSObjection defaultInjector];
        BPScanCodeViewController *scanCodeViewController = injector[[BPScanCodeViewController class]];
        self.viewControllers = @[scanCodeViewController];
    }

    return self;
}

@end