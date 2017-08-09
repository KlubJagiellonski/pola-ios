#import <Objection/Objection.h>
#import "BPScanCodeViewController.h"
#import "BPScanCodeView.h"
#import "BPProductManager.h"
#import "BPTaskRunner.h"
#import "UIAlertView+BPUtilities.h"
#import "NSString+BPUtilities.h"
#import "BPAnalyticsHelper.h"
#import "BPFlashlightManager.h"
#import "BPKeyboardViewController.h"
#import "BPCaptureVideoNavigationController.h"
#import "BPScanResult.h"
#import "BPCapturedImageManager.h"
#import "BPCapturedImagesUploadManager.h"
#import "BPCapturedImageResult.h"

static NSTimeInterval const kAnimationTime = 0.15;

@interface BPScanCodeViewController ()

@property(nonatomic) BPKeyboardViewController *keyboardViewController;
@property(nonatomic, readonly) BPCameraSessionManager *cameraSessionManager;
@property(nonatomic, readonly) BPFlashlightManager *flashlightManager;
@property(nonatomic, readonly) BPTaskRunner *taskRunner;
@property(nonatomic, readonly) BPProductManager *productManager;
@property(nonatomic, readonly) BPCapturedImagesUploadManager *uploadManager;
@property(nonatomic, readonly) BPCapturedImageManager *capturedImageManager;
@property(copy, nonatomic) NSString *lastBardcodeScanned;
@property(nonatomic, readonly) NSMutableArray *scannedBarcodes;
@property(nonatomic, readonly) NSMutableDictionary *barcodeToProductResult;
@property(nonatomic) BOOL addingCardEnabled;

@end


@implementation BPScanCodeViewController

objection_requires_sel(@selector(taskRunner), @selector(productManager), @selector(cameraSessionManager), @selector(flashlightManager), @selector(uploadManager), @selector(capturedImageManager))

- (void)loadView {
    self.view = [[BPScanCodeView alloc] initWithFrame:CGRectZero];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _scannedBarcodes = [NSMutableArray array];
    _barcodeToProductResult = [NSMutableDictionary dictionary];

    self.cameraSessionManager.delegate = self;

    self.addingCardEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.castView.stackView.delegate = self;
    [self.castView.menuButton addTarget:self action:@selector(didTapMenuButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.castView.keyboardButton addTarget:self action:@selector(didTapKeyboardButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.castView.teachButton addTarget:self action:@selector(didTapTeachButton:) forControlEvents:UIControlEventTouchUpInside];

    if (self.flashlightManager.isAvailable) {
        [self.castView.flashButton addTarget:self action:@selector(didTapFlashlightButton:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.castView.flashlightButtonHidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.castView.videoLayer = self.cameraSessionManager.videoPreviewLayer;
    [self.cameraSessionManager start];

    [self updateFlashlightButton];

    [self didFindBarcode:@"5900396019813"];
    [self performSelector:@selector(didFindBarcode:) withObject:@"5901234123457" afterDelay:1.5f];
    [self performSelector:@selector(didFindBarcode:) withObject:@"5900396019813" afterDelay:3.f];
//    [self showReportProblem:productId:@"3123123"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.cameraSessionManager stop];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.keyboardViewController.view.frame = self.view.bounds;
}

#pragma mark - Actions

- (void)showScanCodeView {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self hideKeyboardController];
}

- (void)showWriteCodeView {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self showKeyboardController];
}

- (BOOL)addCardAndDownloadDetails:(NSString *)barcode {
    BPCompanyCardView *cardView = [[BPCompanyCardView alloc] initWithFrame:CGRectZero];
    [cardView setContentType:CompanyContentTypeLoading];
    [cardView setTitleText:NSLocalizedString(@"Loading...", nil)];
    BOOL cardAdded = [self.castView.stackView addCard:cardView];
    if (!cardAdded) {
        return NO;
    }

    cardView.delegate = self;
    cardView.tag = [self.scannedBarcodes count];
    [self.scannedBarcodes addObject:barcode];

    [self.productManager retrieveProductWithBarcode:barcode completion:^(BPScanResult *productResult, NSError *error) {
        if (!error) {
            [BPAnalyticsHelper receivedProductResult:productResult];

            self.barcodeToProductResult[barcode] = productResult;
            [self fillCard:cardView withData:productResult];
        } else {
            self.lastBardcodeScanned = nil;
            self.addingCardEnabled = NO;
            UIAlertView *alertView = [UIAlertView showErrorAlert:NSLocalizedString(@"Cannot fetch product info from server. Please try again.", nil)];
            alertView.delegate = self;
            [self.castView.stackView removeCard:cardView];
        }
    }                               completionQueue:[NSOperationQueue mainQueue]];

    return YES;
}

- (void)fillCard:(BPCompanyCardView *)cardView withData:(BPScanResult *)productResult {
    if (productResult.altText.length == 0) {
        [cardView setContentType:CompanyContentTypeDefault];
        if (productResult.plScore) {
            [cardView setMainPercent:productResult.plScore.intValue / 100.f];
        }
        [cardView setCapitalPercent:productResult.plCapital];
        [cardView setNotGlobal:productResult.plNotGlobEnt];
        [cardView setWorkers:productResult.plWorkers];
        [cardView setRegistered:productResult.plRegistered];
        [cardView setRnd:productResult.plRnD];
        [cardView setDescr:productResult.descr];
    } else {
        [cardView setContentType:CompanyContentTypeAlt];
        [cardView setAltText:productResult.altText];
    }
    
    if (productResult.askForPics) {
        [cardView setTeachButtonText:productResult.askForPicsPreview];
    } else {
        [cardView setTeachButtonText:nil];
    }
    
    [cardView setCardType:productResult.cardType];
    [cardView setReportButtonType:productResult.reportButtonType];
    [cardView setReportButtonText:productResult.reportButtonText];
    [cardView setReportText:productResult.reportText];
    [cardView setTitleText:productResult.name];
    
    UIAccessibilityPostNotification(UIAccessibilityScreenChangedNotification,
                                    cardView.titleLabel);
    
    [self updateTeachButtonWithLastScanResult: productResult cardsStackHeight:self.castView.cardsHeight];
}

- (void)updateTeachButtonWithLastScanResult:(BPScanResult *)scanResult cardsStackHeight:(CGFloat)cardsHeight {
    [self.castView updateTeachButtonWithVisible: (scanResult.askForPics) title: scanResult.askForPicsPreview cardsHeight: cardsHeight];
}

- (void)showReportProblem:(NSString *)barcode productId:(NSNumber *)productId {
    [BPAnalyticsHelper reportShown:barcode];

    JSObjectionInjector *injector = [JSObjection defaultInjector];
    BPReportProblemViewController *reportProblemViewController = [injector getObject:[BPReportProblemViewController class] argumentList:@[productId, barcode]];
    reportProblemViewController.delegate = self;
    [self presentViewController:reportProblemViewController animated:YES completion:nil];
}

- (void)showCaptureVideoWithScanResult:(BPScanResult *)scanResult {
    // TODO: analytics event: capture video navigation controller shown (or seperate events: instruction view shown, capture view shown)
    
    BPCaptureVideoNavigationController *captureVideoNavigationController = [[BPCaptureVideoNavigationController alloc] initWithScanResult: scanResult];
    captureVideoNavigationController.captureDelegate = self;
    [self presentViewController:captureVideoNavigationController animated:YES completion:nil];
}

- (void)didTapMenuButton:(UIButton *)button {
    [BPAnalyticsHelper aboutOpened:@"About Menu"];

    JSObjectionInjector *injector = [JSObjection defaultInjector];
    BPAboutNavigationController *aboutNavigationController = [injector getObject:[BPAboutNavigationController class]];
    aboutNavigationController.infoDelegate = self;
    [self presentViewController:aboutNavigationController animated:YES completion:nil];
}

- (void)didTapKeyboardButton:(UIButton *)button {

    if (self.keyboardViewController.view.superview == nil) {
        [self showKeyboardController];
    } else {
        [self hideKeyboardController];
    }
}

- (void)didTapTeachButton:(UIButton *)button {
    BPScanResult *scanResult = self.barcodeToProductResult[self.lastBardcodeScanned];
    [self showCaptureVideoWithScanResult:scanResult];
}

- (void)didTapFlashlightButton:(UIButton *)button {
    [self.flashlightManager toggleWithCompletionBlock:^(BOOL success) {
        //TODO: Add error message after consultation with UX
    }];

    [self updateFlashlightButton];
}

- (void)updateFlashlightButton {
    [self.castView.flashButton setSelected:self.flashlightManager.isOn];
}

- (void)setAddingCardEnabled:(BOOL)addingCardEnabled {
    _addingCardEnabled = addingCardEnabled;
    [UIApplication sharedApplication].idleTimerDisabled = _addingCardEnabled;
}

- (void)didFindBarcode:(NSString *)barcode sourceType:(NSString *)sourceType {
    if (!self.addingCardEnabled) {
        return;
    }
    
    if (![barcode isValidBarcode]) {
        self.addingCardEnabled = NO;
        
        UIAlertView *alertView = [UIAlertView showErrorAlert:NSLocalizedString(@"Not valid barcode. Please try again.", nil)];
        [alertView setDelegate:self];
        return;
    }
    
    if ([barcode isEqualToString:self.lastBardcodeScanned]) {
        return;
    }
    
    if ([self addCardAndDownloadDetails:barcode]) {
        [BPAnalyticsHelper barcodeScanned:barcode type:sourceType];
        [self.castView setInfoTextVisible:NO];
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        self.lastBardcodeScanned = barcode;
    }
}

#pragma mark - Keyboard Controller

- (void) hideKeyboardController {
    if (self.keyboardViewController == nil) {
        return;
    }
    
    [self.castView.keyboardButton setSelected:NO];

    [self.keyboardViewController willMoveToParentViewController:nil];

    [UIView animateWithDuration:kAnimationTime animations:^{
        self.castView.infoTextLabel.alpha = self.castView.stackView.cardCount > 0 ? 0.0 : 1.0;
        self.castView.rectangleView.alpha = 1.0;
        self.castView.stackView.alpha = 1.0;
        self.keyboardViewController.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.keyboardViewController.view removeFromSuperview];
        [self.keyboardViewController removeFromParentViewController];

        [self.castView configureInfoLabelForMode:BPScanCodeViewLabelModeScan];
        self.keyboardViewController = nil;
        
        if (self.castView.stackView.cardCount != 0) {
            [self.castView setInfoTextVisible:NO];
        }
    }];
}

- (void)showKeyboardController {
    if (self.keyboardViewController != nil) {
        return;
    }
    
    self.keyboardViewController = [[BPKeyboardViewController alloc] init];
    self.keyboardViewController.delegate = self;
    
    [self.castView.keyboardButton setSelected:YES];

    [self addChildViewController:self.keyboardViewController];
    self.keyboardViewController.view.frame = self.view.bounds;
    self.keyboardViewController.view.alpha = 0.0;
    [self.view insertSubview:self.keyboardViewController.view belowSubview:self.castView.logoImageView];

    [UIView animateWithDuration:kAnimationTime animations:^{
        self.keyboardViewController.view.alpha = 1.0;

        self.castView.rectangleView.alpha = 0.0;
        self.castView.stackView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.keyboardViewController didMoveToParentViewController:self];
    }];

    [self.castView configureInfoLabelForMode:BPScanCodeViewLabelModeKeyboard];
    [self.castView setInfoTextVisible:YES];
}

#pragma mark - UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.addingCardEnabled = YES;
}

#pragma mark - Helpers

- (BPScanCodeView *)castView {
    return (BPScanCodeView *) self.view;
}

#pragma mark - BPStackViewDelegate

- (void)stackView:(BPStackView *)stackView willAddCard:(UIView *)cardView {
    [self.castView updateTeachButtonWithVisible:NO title:nil cardsHeight:0.0];
    [self.castView.teachButton setHidden:YES];
}

- (void)stackView:(BPStackView *)stackView didRemoveCard:(UIView *)cardView {

}

- (void)stackView:(BPStackView *)stackView willExpandWithCard:(UIView *)cardView {
    self.addingCardEnabled = NO;

    [self.castView setButtonsVisible:NO animation:YES];

    NSString *barcode = self.scannedBarcodes[(NSUInteger) cardView.tag];
    if (!barcode) {
        return;
    }
    BPScanResult *productResult = self.barcodeToProductResult[barcode];
    if (productResult) {
        [BPAnalyticsHelper opensCard:productResult];
    }
}

- (void)stackViewDidCollapse:(BPStackView *)stackView {
    self.addingCardEnabled = YES;

    [self.castView setButtonsVisible:YES animation:YES];
}

- (BOOL)stackView:(BPStackView *)stackView didTapCard:(UIView *)cardView {
    return NO;
}

#pragma mark - BPCameraSessionManagerDelegate

- (void)didFindBarcode:(NSString *)barcode {
    [self didFindBarcode:barcode sourceType:@"Camera"];
}

#pragma mark - BPProductCardViewDelegate

- (void)productCardViewDidTapReportProblem:(BPCompanyCardView *)productCardView {
    NSString *barcode = self.scannedBarcodes[(NSUInteger) productCardView.tag];
    BPScanResult *scanResult = self.barcodeToProductResult[barcode];
    [self showReportProblem:barcode productId:scanResult.productId];
}

- (void)productCardViewDidTapTeach:(BPCompanyCardView *)productCardView {
    NSString *barcode = self.scannedBarcodes[(NSUInteger) productCardView.tag];
    BPScanResult *scanResult = self.barcodeToProductResult[barcode];
    [self showCaptureVideoWithScanResult:scanResult];
}

#pragma mark - BPCaptureVideoNavigationControllerDelegate

- (void)captureVideoNavigationControllerWantsDismiss:(BPCaptureVideoNavigationController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)captureVideoNavigationController:(BPCaptureVideoNavigationController *)viewController didCaptureImagesWithTimestamp:(int)timestamp imagesData:(BPCapturedImagesData *)imagesData {
    
    UIBackgroundTaskIdentifier __block taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self.capturedImageManager removeImagesDataForCaptureSessionTimestamp:timestamp imageCount:(int)imagesData.filesCount.integerValue];
        [[UIApplication sharedApplication] endBackgroundTask:taskId];
        taskId = UIBackgroundTaskInvalid;
    }];
    
    [self.uploadManager sendImagesWithData:imagesData captureSessionTimestamp:timestamp completion:^(BPCapturedImageResult *result, NSError *error) {
        if (error != nil) {
            if (result.state == CAPTURED_IMAGE_STATE_ADDING) {
                BPLog(@"Failed to get urls for uploading captured images for productID: %@, error: %@", imagesData.productID, error);
                [self.capturedImageManager removeImagesDataForCaptureSessionTimestamp:timestamp imageCount:(int)imagesData.filesCount.integerValue];
                UIAlertView *alertView = [UIAlertView showErrorAlert:NSLocalizedString(@"Failed to upload data. Please try again.", nil)];
                alertView.delegate = self;
                
            } else if (result.state == CAPTURED_IMAGE_STATE_UPLOADING) {
                BPLog(@"Failed to upload captured image for productID: %@, imageIndex: %d, error: %@", imagesData.productID, result.imageIndex, error);
                [self.capturedImageManager removeImageDataForCaptureSessionTimestamp:timestamp imageIndex:result.imageIndex];
            }
            
        } else if (result.state == CAPTURED_IMAGE_STATE_FINISHED) {
            BPLog(@"Uploaded captured image for productID: %@, imageIndex: %d", imagesData.productID, result.imageIndex);
            [self.capturedImageManager removeImageDataForCaptureSessionTimestamp:timestamp imageIndex:(int)result.imageIndex];
        }

    } completionQueue:[NSOperationQueue mainQueue]];
}

#pragma mark - BPReportProblemViewControllerDelegate

- (void)reportProblemWantsDismiss:(BPReportProblemViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reportProblem:(BPReportProblemViewController *)controller finishedWithResult:(BOOL)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BPInfoNavigationControllerDelegate

- (void)infoCancelled:(BPAboutNavigationController *)infoNavigationController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BPKeyboardViewControllerDelegate

- (void)keyboardViewController:(BPKeyboardViewController *) viewController didConfirmWithCode:(NSString *) code {
    [self hideKeyboardController];
    
    [self didFindBarcode:code sourceType: @"Keyboard"];
}

@end
