#import <Objection/Objection.h>
#import "BPScanCodeViewController.h"
#import "BPScanCodeView.h"
#import "BPProductManager.h"
#import "BPProductResult.h"
#import "BPTaskRunner.h"
#import "UIAlertView+BPUtilities.h"
#import "NSString+BPUtilities.h"
#import "BPProductCardView.h"
#import "BPCompany.h"
#import "BPReportProblemViewController.h"
#import "BPMainProggressView.h"


@interface BPScanCodeViewController ()

@property(nonatomic, readonly) BPCameraSessionManager *cameraSessionManager;
@property(nonatomic, readonly) BPTaskRunner *taskRunner;
@property(nonatomic, readonly) BPProductManager *productManager;
@property(nonatomic, strong) NSString *lastBardcodeScanned;
@property(nonatomic, readonly) NSMutableArray *scannedBarcodes;
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

    self.cameraSessionManager.delegate = self;

    self.addingCardEnabled = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.castView.stackView.stackDelegate = self;
    self.title = NSLocalizedString(@"Scan Code", @"");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.castView.videoLayer = self.cameraSessionManager.videoPreviewLayer;
    [self.cameraSessionManager start];

    [self didFindBarcode:@"5900396019813"];
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

    NSString *noDataTitleText = NSLocalizedString(@"help Pola to gain data", @"help Pola to gain data");
    [cardView setTitleText:productResult.verified.boolValue ? (company ? company.name : noDataTitleText) : noDataTitleText];

    if(productResult.plScore) {
        [cardView setMainPercent:productResult.plScore.intValue / 100.f];
    }

    if(!company) {
        return;
    }

    if(company.plCapital) {
        [cardView setCapitalPercent:company.plCapital.intValue / 100.f];
    }
    if(company.plNotGlobEnt) {
        [cardView setNotGlobal:company.plNotGlobEnt.boolValue];
    }
    if(company.plWorkers) {
        [cardView setProducesInPoland:company.plWorkers.boolValue];
    }
    if(company.plRegistered) {
        [cardView setRegisteredInPoland:company.plRegistered.boolValue];
    }
    if(company.plRnD) {
        [cardView setRnd:company.plRnD.boolValue];
    }
}

- (void)saveImageForBarcode:(NSString *)barcode {
    [self.cameraSessionManager captureImageForBarcode:barcode];
}

- (void)showReportProblem:(NSString *)barcode {
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    BPReportProblemViewController *reportProblemViewController = [injector getObject:[BPReportProblemViewController class] argumentList:@[barcode]];
    reportProblemViewController.delegate = self;
    [self presentViewController:reportProblemViewController animated:YES completion:nil];
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

- (void)didTapMore:(BPProductCardView *)view {
    //todo on tap more
}

#pragma mark - BPReportProblemViewControllerDelegate

- (void)reportProblemWantsDismiss:(BPReportProblemViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)reportProblem:(BPReportProblemViewController *)controller finishedWithResult:(BOOL)result {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end