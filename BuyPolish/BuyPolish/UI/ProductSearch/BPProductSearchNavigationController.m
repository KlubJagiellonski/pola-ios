#import <Objection/JSObjection.h>
#import "BPProductSearchNavigationController.h"
#import "BPScanCodeViewController.h"
#import "BPProduct.h"
#import "BPProductInfoViewController.h"
#import "BPProduct+Utilities.h"


@implementation BPProductSearchNavigationController

- (id)init {
    self = [super init];
    if (self) {
        JSObjectionInjector *injector = [JSObjection defaultInjector];
        BPScanCodeViewController *scanCodeViewController = injector[[BPScanCodeViewController class]];
        scanCodeViewController.delegate = self;
        self.viewControllers = @[scanCodeViewController];
    }

    return self;
}

#pragma mark - BPScanCodeViewControllerDelegate

- (void)scanCode:(BPScanCodeViewController *)viewController requestsProductInfo:(BPProduct *)product {
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    UIViewController *viewControllerToPush;
    viewControllerToPush = [injector getObject:[BPProductInfoViewController class] argumentList:@[product]];
    [self pushViewController:viewControllerToPush animated:YES];
}

@end