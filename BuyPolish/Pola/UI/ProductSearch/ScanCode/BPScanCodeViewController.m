#import "BPScanCodeViewController.h"
#import "BPFlashlightManager.h"
#import <Pola-Swift.h>

@import Objection;

static NSTimeInterval const kAnimationTime = 0.15;

@interface BPScanCodeViewController () <CodeScannerManagerDelegate, ResultsViewControllerDelegate>

@property (nonatomic) BPKeyboardViewController *keyboardViewController;
@property (nonatomic) ScannerCodeViewController *scannerCodeViewController;
@property (nonatomic, readonly) BPFlashlightManager *flashlightManager;
@property (nonatomic) ResultsViewController *resultsViewController;

@end

@implementation BPScanCodeViewController

objection_requires_sel(@selector(flashlightManager))

    - (void)loadView {
    self.view = [[BPScanCodeView alloc] initWithFrame:CGRectZero];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scannerCodeViewController = [ScannerCodeViewController fromDiContainer];
    [self addChildViewController:self.scannerCodeViewController];
    ScannerCodeView *scannerView = (ScannerCodeView *)self.scannerCodeViewController.view;
    [self.view insertSubview:scannerView atIndex:0];
    [self.scannerCodeViewController didMoveToParentViewController:self];
    self.scannerCodeViewController.scannerDelegate = self;

    self.resultsViewController = [ResultsViewController fromDiContainer];
    [self addChildViewController:self.resultsViewController];
    [self.view insertSubview:self.resultsViewController.view atIndex:4];
    [self.resultsViewController didMoveToParentViewController:self];
    self.resultsViewController.delegate = self;

    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.castView.menuButton addTarget:self
                                 action:@selector(didTapMenuButton:)
                       forControlEvents:UIControlEventTouchUpInside];
    [self.castView.keyboardButton addTarget:self
                                     action:@selector(didTapKeyboardButton:)
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

    [self.flashlightManager addObserver:self
                             forKeyPath:NSStringFromSelector(@selector(isOn))
                                options:NSKeyValueObservingOptionInitial
                                context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.flashlightManager removeObserver:self forKeyPath:NSStringFromSelector(@selector(isOn))];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.keyboardViewController.view.frame = self.view.bounds;
    self.scannerCodeViewController.view.frame = self.view.bounds;
    self.resultsViewController.view.frame = self.view.bounds;
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

- (void)didTapMenuButton:(UIButton *)button {
    [BPAnalyticsHelper aboutOpened:@"About Menu"];

    UIViewController *vc = [[AboutViewController alloc] init];
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)didTapKeyboardButton:(UIButton *)button {

    if (self.keyboardViewController.view.superview == nil) {
        [self showKeyboardController];
    } else {
        [self hideKeyboardController];
    }
}

- (void)didTapFlashlightButton:(UIButton *)button {
    [self.flashlightManager toggleWithCompletionBlock:^(BOOL success){
        //TODO: Add error message after consultation with UX
    }];
}

- (void)updateFlashlightButton {
    [self.castView.flashButton setSelected:self.flashlightManager.isOn];
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
            self.resultsViewController.view.alpha = 1.0;
            self.scannerCodeViewController.hudView.alpha = 1.0;
            self.keyboardViewController.view.alpha = 0.0;
        }
        completion:^(BOOL finished) {
            [self.keyboardViewController.view removeFromSuperview];
            self.keyboardViewController = nil;
        }];
}

- (void)showKeyboardController {
    if (self.keyboardViewController != nil) {
        return;
    }

    self.keyboardViewController = [BPKeyboardViewController fromDiContainer];
    self.keyboardViewController.delegate = self;

    [self.castView.keyboardButton setSelected:YES];

    [self addChildViewController:self.keyboardViewController];
    self.keyboardViewController.view.frame = self.view.bounds;
    self.keyboardViewController.view.alpha = 0.0;
    [self.view insertSubview:self.keyboardViewController.view belowSubview:self.castView.logoImageView];

    [UIView animateWithDuration:kAnimationTime
        animations:^{
            self.keyboardViewController.view.alpha = 1.0;
            self.resultsViewController.view.alpha = 0.0;
            self.scannerCodeViewController.hudView.alpha = 0.0;
        }
        completion:^(BOOL finished) {
            [self.keyboardViewController didMoveToParentViewController:self];
        }];
}

#pragma mark - Helpers

- (BPScanCodeView *)castView {
    return (BPScanCodeView *)self.view;
}

#pragma mark - CodeScannerManagerDelegate

- (void)didScanBarcode:(NSString *)barcode {
    [self.resultsViewController addWithBarcodeCard:barcode sourceType:@"Camera"];
}

#pragma mark - BPKeyboardViewControllerDelegate

- (void)keyboardViewController:(BPKeyboardViewController *)viewController didConfirmWithCode:(NSString *)code {
    [self hideKeyboardController];
    [self.resultsViewController addWithBarcodeCard:code sourceType:@"Keyboard"];
}

#pragma mark - ResultsViewControllerDelegate

- (void)resultsViewControllerDidCollapse {
    self.castView.buttonsVisible = YES;
}

- (void)resultsViewControllerWillExpandResult {
    self.castView.buttonsVisible = NO;
}

@end
