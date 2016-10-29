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

static NSTimeInterval const kAnimationTime = 0.15;

@interface BPScanCodeViewController ()

@property(nonatomic) BPKeyboardViewController *keyboardViewController;
@property(nonatomic, readonly) BPCameraSessionManager *cameraSessionManager;
@property(nonatomic, readonly) BPFlashlightManager *flashlightManager;
@property(nonatomic, readonly) BPTaskRunner *taskRunner;
@property(nonatomic, readonly) BPProductManager *productManager;
@property(copy, nonatomic) NSString *lastBardcodeScanned;
@property(nonatomic, readonly) NSMutableArray *scannedBarcodes;
@property(nonatomic, readonly) NSMutableDictionary *barcodeToProductResult;
@property(nonatomic) BOOL addingCardEnabled;

@end


@implementation BPScanCodeViewController

objection_requires_sel(@selector(taskRunner), @selector(productManager), @selector(cameraSessionManager), @selector(flashlightManager))

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
//    [self performSelector:@selector(didFindBarcode:) withObject:@"5901234123457" afterDelay:1.5f];
//    [self performSelector:@selector(didFindBarcode:) withObject:@"5900396019813" afterDelay:3.f];
//    [self showReportProblem:productId:@"3123123"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.cameraSessionManager stop];
}

#pragma mark - Actions

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

    [cardView setCardType:productResult.cardType];
    [cardView setReportButtonType:productResult.reportButtonType];
    [cardView setReportButtonText:productResult.reportButtonText];
    [cardView setReportText:productResult.reportText];
    [cardView setTitleText:productResult.name];
}

- (void)showReportProblem:(NSString *)barcode productId:(NSNumber *)productId {
    [BPAnalyticsHelper reportShown:barcode];

    JSObjectionInjector *injector = [JSObjection defaultInjector];
    BPReportProblemViewController *reportProblemViewController = [injector getObject:[BPReportProblemViewController class] argumentList:@[productId, barcode]];
    reportProblemViewController.delegate = self;
    [self presentViewController:reportProblemViewController animated:YES completion:nil];
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

#pragma mark - Keyboard Controller

- (void) hideKeyboardController {
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
    }];
}

- (void)showKeyboardController {
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
        [BPAnalyticsHelper barcodeScanned:barcode];
        [self.castView setInfoTextVisible:NO];
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        self.lastBardcodeScanned = barcode;
    }
}

#pragma mark - BPProductCardViewDelegate

- (void)didTapReportProblem:(BPCompanyCardView *)productCardView {
    NSString *barcode = self.scannedBarcodes[(NSUInteger) productCardView.tag];
    BPScanResult *scanResult = self.barcodeToProductResult[barcode];
    [self showReportProblem:barcode productId:scanResult.productId];
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
    
    [self didFindBarcode:code];
}

@end
