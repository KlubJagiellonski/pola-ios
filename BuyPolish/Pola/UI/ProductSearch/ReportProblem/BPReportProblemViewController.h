//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPImageContainerView.h"
#import "BPKeyboardManager.h"

@class BPReportProblemViewController;

@protocol BPReportProblemViewControllerDelegate <NSObject>
- (void)reportProblemWantsDismiss:(BPReportProblemViewController *)viewController;

- (void)reportProblem:(BPReportProblemViewController *)controller finishedWithResult:(BOOL)result;
@end


@interface BPReportProblemViewController : UIViewController <BPImageContainerViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, BPKeyboardManagerDelegate>

@property(nonatomic, weak) id <BPReportProblemViewControllerDelegate> delegate;

@property(nonatomic, readonly) NSString *barcode;

- (instancetype)initWithBarcode:(NSString *)barcode;

@end