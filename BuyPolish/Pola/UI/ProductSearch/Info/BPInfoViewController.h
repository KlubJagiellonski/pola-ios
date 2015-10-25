//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPInfoViewController;

@protocol BPInfoViewControllerDelegate <NSObject>
- (void)infoCancelled:(BPInfoViewController *)viewController;
@end


@interface BPInfoViewController : UITableViewController

@property(nonatomic, weak) id <BPInfoViewControllerDelegate> delegate;

@end