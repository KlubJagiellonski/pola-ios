//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Objection/JSObjectionInjector.h>
#import "BPInfoNavigationController.h"
#import "JSObjection.h"
#import "BPInfoViewController.h"


@implementation BPInfoNavigationController

- (instancetype)init {
    self = [super init];
    if (self) {
        JSObjectionInjector *injector = [JSObjection defaultInjector];
        BPInfoViewController *infoViewController = injector[[BPInfoViewController class]];
        infoViewController.delegate = self;
        self.viewControllers = @[infoViewController];
    }

    return self;
}

- (void)infoCancelled:(BPInfoViewController *)viewController {
    [self.infoDelegate infoCancelled:self];
}


@end