#import <Objection/JSObjection.h>
#import "BPRootViewController.h"
#import "BPProductSearchNavigationController.h"


@implementation BPRootViewController

- (id)init {
    self = [super init];
    if (self) {
        JSObjectionInjector *injector = [JSObjection defaultInjector];
        BPProductSearchNavigationController *productSearchNavigationController = injector[[BPProductSearchNavigationController class]];
        self.viewControllers = @[productSearchNavigationController];
    }

    return self;
}

@end