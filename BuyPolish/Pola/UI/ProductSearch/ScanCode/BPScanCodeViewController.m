#import "BPScanCodeViewController.h"
#import "BPAboutWebViewController.h"
#import "BPCaptureVideoNavigationController.h"
#import "BPCapturedImageResult.h"
#import "BPFlashlightManager.h"
#import "BPKeyboardViewController.h"
#import "BPProductManager.h"
#import "BPScanResult.h"
#import "NSString+BPUtilities.h"
#import <Pola-Swift.h>

@import Objection;

static NSTimeInterval const kAnimationTime = 0.15;

@interface BPScanCodeViewController () <ScanResultViewControllerDelegate, CardStackViewControllerDelegate>

@property (nonatomic) BPKeyboardViewController *keyboardViewController;
@property (nonatomic, readonly) BPCameraSessionManager *cameraSessionManager;
@property (nonatomic, readonly) BPFlashlightManager *flashlightManager;
@property (nonatomic, readonly) BPProductManager *productManager;
@property (copy, nonatomic) NSString *lastBardcodeScanned;
@property (nonatomic) BOOL addingCardEnabled;
@property (nonatomic) CardStackViewController *stackViewController;

@end

@implementation BPScanCodeViewController

objection_requires_sel(@selector(productManager), @selector(cameraSessionManager), @selector(flashlightManager))

    - (void)loadView {
    self.stackViewController = [[CardStackViewController alloc] init];
    self.stackViewController.delegate = self;
    [self addChildViewController:self.stackViewController];
    CardStackView *stackView = (CardStackView *)self.stackViewController.view;
    self.view = [[BPScanCodeView alloc] initWithFrame:CGRectZero stackView:stackView];
    [self.stackViewController didMoveToParentViewController:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.cameraSessionManager.delegate = self;

    self.addingCardEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.stackViewController.delegate = self;
    [self.castView.menuButton addTarget:self
                                 action:@selector(didTapMenuButton:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.castView.keyboardButton addTarget:self
                                     action:@selector(didTapKeyboardButton:)
                           forControlEvents:UIControlEventTouchUpInside];
    [self.castView.teachButton addTarget:self
                                  action:@selector(didTapTeachButton:)
                        forControlEvents:UIControlEventTouchUpInside];

    if (self.flashlightManager.isAvailable) {
        [self.castView.flashButton addTarget:self
                                      action:@selector(didTapFlashlightButton:)
                            forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.castView.flashButton.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.castView.videoLayer = self.cameraSessionManager.videoPreviewLayer;
    [self.cameraSessionManager start];

    [self.flashlightManager addObserver:self
                             forKeyPath:NSStringFromSelector(@selector(isOn))
                                options:NSKeyValueObservingOptionInitial
                                context:nil];

    //    [self didFindBarcode:@"5900396019813"];
    //    [self performSelector:@selector(didFindBarcode:) withObject:@"5901234123457" afterDelay:1.5f];
    //    [self performSelector:@selector(didFindBarcode:) withObject:@"5900396019813" afterDelay:3.f];
    //    [self showReportProblem:productId:@"3123123"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.cameraSessionManager stop];
    [self.flashlightManager removeObserver:self forKeyPath:NSStringFromSelector(@selector(isOn))];
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
    ScanResultViewController *cardViewController =
        [[ScanResultViewController alloc] initWithBarcode:barcode productManager:self.productManager];
    cardViewController.delegate = self;
    BOOL added = [self.stackViewController addCard:cardViewController];
    return added;
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

- (void)didTapWebViewCloseButton:(UIButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didTapTeachButton:(UIButton *)button {
    //TODO: Use last scanResultViewController to show teach
}

- (void)didTapFlashlightButton:(UIButton *)button {
    [self.flashlightManager toggleWithCompletionBlock:^(BOOL success){
        //TODO: Add error message after consultation with UX
    }];
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

        UIAlertView *alertView =
            [UIAlertView showErrorAlert:NSLocalizedString(@"Not valid barcode. Please try again.", nil)];
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

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
    if (object == self.flashlightManager && keyPath == NSStringFromSelector(@selector(isOn))) {
        [self updateFlashlightButton];
    }
}

#pragma mark - Keyboard Controller

- (void)hideKeyboardController {
    if (self.keyboardViewController == nil) {
        return;
    }

    [self.castView.keyboardButton setSelected:NO];

    [self.keyboardViewController willMoveToParentViewController:nil];

    [UIView animateWithDuration:kAnimationTime
        animations:^{
            self.castView.infoTextLabel.alpha = self.stackViewController.cardCount > 0 ? 0.0 : 1.0;
            self.castView.rectangleView.alpha = 1.0;
            self.stackViewController.view.alpha = 1.0;
            self.castView.teachButton.alpha = 1.0;
            self.keyboardViewController.view.alpha = 0.0;
        }
        completion:^(BOOL finished) {
            [self.keyboardViewController.view removeFromSuperview];

            self.castView.infoTextLabel.text = NSLocalizedString(@"Scan barcode", nil);
            self.keyboardViewController = nil;

            if (self.stackViewController.cardCount != 0) {
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

    [UIView animateWithDuration:kAnimationTime
        animations:^{
            self.keyboardViewController.view.alpha = 1.0;

            self.castView.rectangleView.alpha = 0.0;
            self.stackViewController.view.alpha = 0.0;
            self.castView.teachButton.alpha = 0.0;
        }
        completion:^(BOOL finished) {
            [self.keyboardViewController didMoveToParentViewController:self];
        }];

    self.castView.infoTextLabel.text = NSLocalizedString(@"Type 13 digits", nil);
    [self.castView setInfoTextVisible:YES];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.addingCardEnabled = YES;
}

#pragma mark - Helpers

- (BPScanCodeView *)castView {
    return (BPScanCodeView *)self.view;
}

#pragma mark - BPStackViewControllerDelegate

- (void)stackViewController:(CardStackViewController *)stackViewController willAddCard:(UIViewController *)card {
    UIButton *teachButton = self.castView.teachButton;
    teachButton.hidden = YES;
    [teachButton setNeedsLayout];
}

- (void)stackViewController:(CardStackViewController *)stackViewController didRemoveCard:(UIViewController *)card {
}

- (void)stackViewController:(CardStackViewController *)stackViewController willExpandCard:(UIViewController *)card {
    self.addingCardEnabled = NO;
    self.castView.buttonsVisible = NO;

    // TODO [BPAnalyticsHelper opensCard:productResult]
}

- (void)stackViewControllerDidCollapse:(CardStackViewController *)stackViewController {
    self.addingCardEnabled = YES;
    self.castView.buttonsVisible = YES;
}

#pragma mark - BPCameraSessionManagerDelegate

- (void)didFindBarcode:(NSString *)barcode {
    [self didFindBarcode:barcode sourceType:@"Camera"];
}

#pragma mark - BPInfoNavigationControllerDelegate

- (void)infoCancelled:(BPAboutNavigationController *)infoNavigationController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - BPKeyboardViewControllerDelegate

- (void)keyboardViewController:(BPKeyboardViewController *)viewController didConfirmWithCode:(NSString *)code {
    [self hideKeyboardController];

    [self didFindBarcode:code sourceType:@"Keyboard"];
}

#pragma mark - ScanResultViewControllerDelegate

- (void)scanResultViewController:(ScanResultViewController *)vc didFailFetchingScanResultWithError:(NSError *)error {
    UIAlertView *alertView = [UIAlertView
        showErrorAlert:NSLocalizedString(@"Cannot fetch product info from server. Please try again.", nil)];
    alertView.delegate = self;
    [self.stackViewController removeCard:vc];
}

- (void)scanResultViewController:(ScanResultViewController *)vc didFetchResult:(BPScanResult *)result {
    BOOL visible = result.askForPics;
    UIButton *teachButton = self.castView.teachButton;
    teachButton.hidden = !visible;
    [teachButton setTitle:result.askForPicsPreview forState:UIControlStateNormal];
    [teachButton setNeedsLayout];
}

- (void)scanResultViewControllerDidSentTeachReport:(ScanResultViewController *)vc {
    UIButton *teachButton = self.castView.teachButton;
    teachButton.hidden = YES;
    [teachButton setNeedsLayout];
}

@end
