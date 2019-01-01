#import "BPAboutNavigationController.h"
#import "BPAboutViewController.h"
#import "BPAboutWebViewController.h"
@import Objection;

@implementation BPAboutNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        JSObjectionInjector *injector = [JSObjection defaultInjector];
        BPAboutViewController *infoViewController = injector[[BPAboutViewController class]];
        infoViewController.delegate = self;
        self.viewControllers = @[infoViewController];
    }

    return self;
}

- (void)infoCancelled:(BPAboutViewController *)viewController {
    [self.infoDelegate infoCancelled:self];
}

- (void)showWebWithUrl:(NSString *)url title:(NSString *)title {
    BPAboutWebViewController *webViewController = [[BPAboutWebViewController alloc] initWithUrl:url title:title];
    [self pushViewController:webViewController animated:YES];
}

@end
