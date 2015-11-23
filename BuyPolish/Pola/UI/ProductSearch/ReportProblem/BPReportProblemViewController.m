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
#import "BPAnalyticsHelper.h"


@interface BPReportProblemViewController ()
@property(nonatomic) BPProductImageManager *productImageManager;
@property(nonatomic) BPReportManager *reportManager;
@property(nonatomic) BPKeyboardManager *keyboardManager;
@property(nonatomic) int imageCount;
@property(nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation BPReportProblemViewController
objection_initializer_sel(@selector(initWithProductId:barcode:))

objection_requires_sel(@selector(productImageManager), @selector(reportManager), @selector(keyboardManager))

- (instancetype)initWithProductId:(NSNumber *)productId barcode:(NSString *)barcode {
    self = [super init];
    if (self) {
        _productId = productId;
        _barcode = barcode;
    }
    return self;
}

- (void)loadView {
    self.view = [[BPReportProblemView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.keyboardManager.delegate = self;

    self.castView.imageContainerView.delegate = self;
    [self.castView.closeButton addTarget:self action:@selector(didTapCloseButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.castView.sendButton addTarget:self action:@selector(didTapSendButton:) forControlEvents:UIControlEventTouchUpInside];

    [self initializeImages];

    [self updateReportButtonState];
}

- (void)initializeImages {
    self.imageCount = [self.productImageManager isImageExistForKey:self.productId index:0] ? 1 : 0;
    if (self.imageCount == 1) {
        UIImage *image = [self.productImageManager retrieveImageForKey:self.productId index:0 small:YES];
        [self.castView.imageContainerView addImage:image];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.keyboardManager turnOn];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.keyboardManager turnOff];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

#pragma mark - actions

- (void)updateReportButtonState {
    self.castView.sendButton.enabled = self.imageCount > 0;
}

- (void)didTapCloseButton:(UIButton *)button {
    [self.delegate reportProblemWantsDismiss:self];
}

- (void)didTapSendButton:(UIButton *)button {
    [self.view endEditing:YES];

    NSArray *imagePathArray = [self.productImageManager createImagePathArrayForKey:self.productId imageCount:self.imageCount];
    BPReport *report = [BPReport reportWithProductId:self.productId description:self.castView.descriptionTextView.text imagePathArray:imagePathArray];

    [KVNProgress showWithStatus:NSLocalizedString(@"Sending...", @"Wysyłanie...")];

    weakify()
    [self.reportManager sendReport:report completion:^(BPReportResult *result, NSError *error) {
        strongify()
        if (result.state == REPORT_STATE_FINSIHED && error == nil) {
            [KVNProgress showSuccessWithStatus:NSLocalizedString(@"Report sent", @"Raport wysłany")];
            [BPAnalyticsHelper reportSent:self.barcode success:YES];
            [strongSelf.delegate reportProblem:strongSelf finishedWithResult:YES];
        } else if (error != nil) {
            [KVNProgress showErrorWithStatus:NSLocalizedString(@"Error occured", @"Wystąpił błąd")];
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
    [imageContainerView removeImageAtIndex:index];
    self.imageCount--;

    [self updateReportButtonState];
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
    [self.productImageManager saveImage:image forKey:self.productId index:self.imageCount];

    UIImage *smallImage = [self.productImageManager retrieveImageForKey:self.productId index:self.imageCount small:YES];
    [self.castView.imageContainerView addImage:smallImage];

    self.imageCount++;

    [self updateReportButtonState];

    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - BPKeyboardManagerDelegate

- (void)keyboardWillShowWithHeight:(CGFloat)height animationDuration:(double)animationDuration animationCurve:(NSUInteger)animationCurve {
    [self.castView keyboardWillShowWithHeight:height duration:animationDuration curve:animationCurve];
}

- (void)keyboardWillHideWithAnimationDuration:(double)animationDuration animationCurve:(NSUInteger)animationCurve {
    [self.castView keyboardWillHideWithDuration:animationDuration curve:animationCurve];
}

@end