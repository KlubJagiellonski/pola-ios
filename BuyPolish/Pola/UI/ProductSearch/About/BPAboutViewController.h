//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <MessageUI/MessageUI.h>
#import <Foundation/Foundation.h>
#import "BPReportProblemViewController.h"

@class BPAboutViewController;

@protocol BPInfoViewControllerDelegate <NSObject>
- (void)infoCancelled:(BPAboutViewController *)viewController;

- (void)showWebWithUrl:(NSString *)url title:(NSString *)title;
@end


@interface BPAboutViewController : UITableViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, BPReportProblemViewControllerDelegate>

@property(nonatomic, weak) id <BPInfoViewControllerDelegate> delegate;

@end