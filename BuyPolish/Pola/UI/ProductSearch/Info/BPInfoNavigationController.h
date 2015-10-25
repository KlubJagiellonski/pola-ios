//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPInfoViewController.h"

@class BPInfoNavigationController;


@protocol BPInfoNavigationControllerDelegate <NSObject>
- (void)infoCancelled:(BPInfoNavigationController *)infoNavigationController;
@end


@interface BPInfoNavigationController : UINavigationController <BPInfoViewControllerDelegate>

@property(nonatomic, weak) id <BPInfoNavigationControllerDelegate> infoDelegate;

@end