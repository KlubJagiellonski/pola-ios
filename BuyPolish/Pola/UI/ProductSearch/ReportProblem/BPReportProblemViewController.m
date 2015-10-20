//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Objection/Objection.h>
#import "BPReportProblemViewController.h"
#import "BPProductImageManager.h"
#import "BPReportProblemView.h"
#import "BPReportManager.h"
#import "BPReport.h"
#import "BPReportResult.h"
#import "KVNProgress.h"


@interface BPReportProblemViewController ()
@property(nonatomic) BPProductImageManager *productImageManager;
@property(nonatomic) BPReportManager *reportManager;
@property(nonatomic, readonly) NSString *barcode;
@property(nonatomic) int imageCount;
@property(nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation BPReportProblemViewController
objection_initializer_sel(@selector(initWithBarcode:))

objection_requires_sel(@selector(productImageManager), @selector(reportManager))

- (instancetype)initWithBarcode:(NSString *)barcode {
    self = [super init];
    if (self) {
        _barcode = barcode;
    }
    return self;
}

- (void)loadView {
    self.view = [[BPReportProblemView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.castView.imageContainerView.delegate = self;
    [self.castView.closeButton addTarget:self action:@selector(didTapCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.castView.sendButton addTarget:self action:@selector(didTapSendButton:) forControlEvents:UIControlEventTouchUpInside];

    [self initializeImages];
}

- (void)initializeImages {
    self.imageCount = [self.productImageManager isImageExistForBarcode:self.barcode index:0] ? 1 : 0;
    if (self.imageCount == 1) {
        UIImage *image = [self.productImageManager retrieveImageForBarcode:self.barcode index:0 small:YES];
        [self.castView.imageContainerView addImage:image];
    }
}

#pragma mark - actions

- (void)didTapCloseButton:(UIButton *)button {
    [self.delegate reportProblemWantsDismiss:self];
}

- (void)didTapSendButton:(UIButton *)button {
    NSArray *imagePathArray = [self.productImageManager createImagePathArrayForBarcode:self.barcode imageCount:self.imageCount];
    BPReport *report = [BPReport reportWithBarcode:self.barcode description:self.castView.descriptionTextView.text imagePathArray:imagePathArray];

    [KVNProgress show];

    weakify()
    [self.reportManager sendReport:report completion:^(BPReportResult *result, NSError *error) {
        strongify()
        if (result.state == REPORT_STATE_FINSIHED && error == nil) {
            [KVNProgress showSuccess];
            [strongSelf.delegate reportProblem:strongSelf finishedWithResult:YES];
        } else if (error != nil) {
            [KVNProgress showError];
            [strongSelf.delegate reportProblem:strongSelf finishedWithResult:NO];
        }
    }              completionQueue:[NSOperationQueue mainQueue]];
}

- (void)showImagePickerForSourceType:(enum UIImagePickerControllerSourceType)sourceType {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;

    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - helpers

- (BPReportProblemView *)castView {
    return (BPReportProblemView *) self.view;
}

#pragma mark - BPImageContainerViewDelegate

- (void)didTapAddImage:(BPImageContainerView *)imageContainerView {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:NSLocalizedString(@"Take a photo", @"Take a photo"), NSLocalizedString(@"Choose from library", @"Choose from library"), nil];
    [sheet showInView:self.view];
}

- (void)didTapRemoveImage:(BPImageContainerView *)imageContainerView atIndex:(int)index {

}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }

    if (buttonIndex == [actionSheet firstOtherButtonIndex]) {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
    } else if (buttonIndex == [actionSheet firstOtherButtonIndex] + 1) {
        [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.productImageManager saveImage:image forBarcode:self.barcode index:self.imageCount];

    UIImage *smallImage = [self.productImageManager retrieveImageForBarcode:self.barcode index:self.imageCount small:YES];
    [self.castView.imageContainerView addImage:smallImage];

    self.imageCount++;

    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end