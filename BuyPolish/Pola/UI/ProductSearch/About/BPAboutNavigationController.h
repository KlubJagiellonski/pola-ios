//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPAboutViewController.h"

@class BPAboutNavigationController;


@protocol BPInfoNavigationControllerDelegate <NSObject>
- (void)infoCancelled:(BPAboutNavigationController *)infoNavigationController;
@end


@interface BPAboutNavigationController : UINavigationController <BPInfoViewControllerDelegate>

@property(nonatomic, weak) id <BPInfoNavigationControllerDelegate> infoDelegate;

@end