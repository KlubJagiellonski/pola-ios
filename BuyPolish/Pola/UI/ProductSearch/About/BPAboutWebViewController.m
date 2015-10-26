//
// Created by Paweł Janeczek on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

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
}

- (UIWebView *)castView {
    return (UIWebView *) self.view;
}

@end