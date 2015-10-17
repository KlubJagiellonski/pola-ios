//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPImageContainerView.h"

@class BPReportProblemViewController;

@protocol BPReportProblemViewControllerDelegate <NSObject>
- (void)reportProblemWantsDismiss:(BPReportProblemViewController *)viewController;
@end


@interface BPReportProblemViewController : UIViewController <BPImageContainerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property(nonatomic, weak) id <BPReportProblemViewControllerDelegate> delegate;

- (instancetype)initWithBarcode:(NSString *)barcode;

@end