#import "BPAboutWebViewController.h"

@implementation BPAboutWebViewController

- (instancetype)initWithUrl:(NSString *)url title:(NSString *)title {
    self = [super init];
    if (self) {
        _url = url;
        self.title = title;
    }

    return self;
}

- (void)loadView {
    self.view = [[UIWebView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.castView loadRequest:[NSURLRequest requestWithURL:[[NSURL alloc] initWithString:self.url]]];
    self.castView.delegate = self;
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView
    shouldStartLoadWithRequest:(NSURLRequest *)request
                navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeOther) {
        return YES;
    }

    [[UIApplication sharedApplication] openURL:request.URL];
    return NO;
}

#pragma mark - Helpers

- (UIWebView *)castView {
    return (UIWebView *)self.view;
}

@end
