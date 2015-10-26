#import <Objection/Objection.h>
#import <Crashlytics/Crashlytics.h>
#import "BPScanCodeViewController.h"
#import "BPScanCodeView.h"
#import "BPProductManager.h"
#import "BPProductResult.h"
#import "BPTaskRunner.h"
#import "UIAlertView+BPUtilities.h"
#import "NSString+BPUtilities.h"
#import "BPCompany.h"
#import "BPAboutNavigationController.h"
#import "BPAnalyticsHelper.h"


@interface BPScanCodeViewController ()

@property(nonatomic, readonly) BPCameraSessionManager *cameraSessionManager;
@property(nonatomic, readonly) BPTaskRunner *taskRunner;
@property(nonatomic, readonly) BPProductManager *productManager;
@property(nonatomic, strong) NSString *lastBardcodeScanned;
@property(nonatomic, readonly) NSMutableArray *scannedBarcodes;
@property(nonatomic, readonly) NSMutableDictionary *barcodeToProductResult;
@property(nonatomic) BOOL addingCardEnabled;

@end


@implementation BPScanCodeViewController

objection_requires_sel(@selector(taskRunner), @selector(productManager), @selector(cameraSessionManager))

- (void)loadView {
    self.view = [[BPScanCodeView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _scannedBarcodes = [NSMutableArray array];
    _barcodeToProductResult = [NSMutableDictionary dictionary];

    self.cameraSessionManager.delegate = self;

    self.addingCardEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.castView.stackView.stackDelegate = self;
    self.title = NSLocalizedString(@"Scan Code", @"");
    [self.castView.menuButton addTarget:self action:@selector(didTapMenuButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.castView.videoLayer = self.cameraSessionManager.videoPreviewLayer;
    [self.cameraSessionManager start];

//    [self didFindBarcode:@"5900396019813"];
//    [self showReportProblem:@"3123123"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.cameraSessionManager stop];
}

#pragma mark - Actions

- (BOOL)addCardAndDownloadDetails:(NSString *)barcode {
    BPProductCardView *cardView = [[BPProductCardView alloc] initWithFrame:CGRectZero];
    cardView.inProgress = YES;
    [cardView setTitleText:NSLocalizedString(@"Loading...", @"Loading...")];
    BOOL cardAdded = [self.castView.stackView addCard:cardView];
    if (!cardAdded) {
        return NO;
    }

    cardView.delegate = self;
    cardView.tag = [self.scannedBarcodes count];
    [self.scannedBarcodes addObject:barcode];

    [self.productManager retrieveProductWithBarcode:barcode completion:^(BPProductResult *productResult, NSError *error) {
        cardView.inProgress = NO;
        if (!error) {
            [BPAnalyticsHelper receivedProductResult:productResult];

            self.barcodeToProductResult[barcode] = productResult;
            [self fillCard:cardView withData:productResult];
        } else {
            self.lastBardcodeScanned = nil;
            [UIAlertView showErrorAlert:NSLocalizedString(@"Cannot fetch product info from server. Please try again.", @"")];
        }
    }                               completionQueue:[NSOperationQueue mainQueue]];

    return YES;
}

- (void)fillCard:(BPProductCardView *)cardView withData:(BPProductResult *)productResult {
    BPCompany *company = productResult.company;

    [cardView setNeedsData:!productResult.verified.boolValue];

    [cardView setTitleText:company ? company.name : NSLocalizedString(@"help Pola to gain data", @"help Pola to gain data")];

    if (productResult.plScore) {
        [cardView setMainPercent:productResult.plScore.intValue / 100.f];
    }

    if (!company) {
        return;
    }

    [cardView setCapitalPercent:company.plCapital];
    [cardView setNotGlobal:company.plNotGlobEnt];
    [cardView setProducesInPoland:company.plWorkers];
    [cardView setRegisteredInPoland:company.plRegistered];
    [cardView setRnd:company.plRnD];
}

- (void)saveImageForBarcode:(NSString *)barcode {
    [self.cameraSessionManager captureImageForBarcode:barcode];
}

- (void)showReportProblem:(NSString *)barcode {
    [BPAnalyticsHelper reportShown:barcode];

    JSObjectionInjector *injector = [JSObjection defaultInjector];
    BPReportProblemViewController *reportProblemViewController = [injector getObject:[BPReportProblemViewController class] argumentList:@[barcode]];
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

#pragma mark - UIAlertViewDelegate


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    self.addingCardEnabled = YES;
}

#pragma mark - Helpers

- (BPScanCodeView *)castView {
    return (BPScanCodeView *) self.view;
}

#pragma mark - BPStackViewDelegate

- (void)willAddCard:(UIView <BPCardViewProtocol> *)cardView withAnimationDuration:(CGFloat)animationDuration {

}

- (void)willEnterFullScreen:(UIView <BPCardViewProtocol> *)cardView withAnimationDuration:(CGFloat)animationDuration {
    self.addingCardEnabled = NO;

    NSString *barcode = self.scannedBarcodes[(NSUInteger) cardView.tag];
    if(!barcode) {
        return;
    }
    BPProductResult *productResult = self.barcodeToProductResult[barcode];
    if(productResult) {
        [BPAnalyticsHelper opensCard:productResult];
    }
}

- (void)didExitFullScreen:(UIView <BPCardViewProtocol> *)cardView {
    self.addingCardEnabled = YES;
}

#pragma mark - BPCameraSessionManagerDelegate

- (void)didFindBarcode:(NSString *)barcode {
    if (!self.addingCardEnabled) {
        return;
    }

    if (![barcode isValidBarcode]) {
        self.addingCardEnabled = NO;

        UIAlertView *alertView = [UIAlertView showErrorAlert:NSLocalizedString(@"Not valid barcode. Please try again.", @"Not valid barcode. Please try again.")];
        [alertView setDelegate:self];
        return;
    }

    if ([barcode isEqualToString:self.lastBardcodeScanned]) {
        return;
    }

    if ([self addCardAndDownloadDetails:barcode]) {
        [BPAnalyticsHelper barcodeScanned:barcode];
        [self.castView setInfoTextVisible:NO];
        [self saveImageForBarcode:barcode];
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        self.lastBardcodeScanned = barcode;
    }
}

#pragma mark - BPProductCardViewDelegate

- (void)didTapReportProblem:(BPProductCardView *)productCardView {
    NSString *barcode = self.scannedBarcodes[(NSUInteger) productCardView.tag];

    [self showReportProblem:barcode];
}

#pragma mark - BPReportProblemViewControllerDelegate

- (void)reportProblemWantsDismiss:(BPReportProblemViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reportProblem:(BPReportProblemViewController *)controller finishedWithResult:(BOOL)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    [BPAnalyticsHelper reportSent:controller.barcode success:result];
}

#pragma mark - BPInfoNavigationControllerDelegate

- (void)infoCancelled:(BPAboutNavigationController *)infoNavigationController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end