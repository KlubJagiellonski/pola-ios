#import <Objection/Objection.h>
#import "BPScanCodeViewController.h"
#import "BPScanCodeView.h"
#import "BPProductManager.h"
#import "BPProductResult.h"
#import "BPTaskRunner.h"
#import "UIAlertView+BPUtilities.h"
#import "NSString+BPUtilities.h"
#import "BPCardView.h"


@interface BPScanCodeViewController ()

@property(nonatomic, strong) AVCaptureSession *captureSession;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, readonly) BPTaskRunner *taskRunner;
@property(nonatomic, readonly) BPProductManager *productManager;
@property(nonatomic, strong) NSString *lastBardcodeScanned;
@property(nonatomic) BOOL addingCardEnabled;

@end


@implementation BPScanCodeViewController

objection_requires_sel(@selector(taskRunner), @selector(productManager))

- (void)loadView {
    self.view = [[BPScanCodeView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.addingCardEnabled = YES;

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.castView.stackView.stackDelegate = self;

    [self setupCaptureSession];

    self.title = NSLocalizedString(@"Scan Code", @"");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupVideoLayer];
    [_captureSession startRunning];
}

- (void)addCard {
    BPCardView *cardView = [[BPCardView alloc] initWithFrame:CGRectZero];
    cardView.backgroundColor = self.castView.stackView.cardCount % 2 == 0 ? [UIColor redColor] : [UIColor yellowColor];
    [self.castView.stackView addCard:cardView];
}

#pragma mark - Actions

- (void)foundBarcode:(NSString *)barcode corners:(NSArray *)corners {
    if(!self.addingCardEnabled) {
        return;
    }

    if (![barcode isValidBarcode]) {
        [self.captureSession startRunning];

        UIAlertView *alertView = [UIAlertView showErrorAlert:NSLocalizedString(@"Not valid barcode. Please try again.", @"Not valid barcode. Please try again.")];
        [alertView setDelegate:self];
        return;
    }

    if ([barcode isEqualToString:self.lastBardcodeScanned]) {
        return;
    }

    if ([self addCardAndDownloadDetails:barcode]) {
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        self.lastBardcodeScanned = barcode;
    }
}

- (BOOL)addCardAndDownloadDetails:(NSString *)barcode {
    BPCardView *cardView = [[BPCardView alloc] initWithFrame:CGRectZero];
    cardView.inProgress = YES;
    cardView.barcode = barcode;
    BOOL cardAdded = [self.castView.stackView addCard:cardView];
    if (!cardAdded) {
        return NO;
    }

    [self.productManager retrieveProductWithBarcode:barcode completion:^(BPProductResult *productResult, NSError *error) {
        cardView.inProgress = NO;
        if (!error) {
            cardView.verified = productResult.verified.boolValue;
            //todo update cardview
        } else {
            self.lastBardcodeScanned = nil;
            [UIAlertView showErrorAlert:NSLocalizedString(@"Cannot fetch product info from server. Please try again.", @"")];
        }
    }                               completionQueue:[NSOperationQueue mainQueue]];

    return YES;
}

#pragma mark - Capture session

- (void)setupVideoLayer {
    if (_captureSession) {
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [self.castView addVideoPreviewLayer:_videoPreviewLayer];
    }
}

- (void)setupCaptureSession {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];

    if (input) {
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession addInput:input];
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [_captureSession addOutput:captureMetadataOutput];

        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code]];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        NSObject *metadataObj = metadataObjects.firstObject;
        if (![metadataObj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            return;
        }
        AVMetadataMachineReadableCodeObject *readableMetadataObj = (AVMetadataMachineReadableCodeObject *) metadataObj;

        NSString *barcode = readableMetadataObj.stringValue;
        BPLog(@"Found barcode: %@", barcode);
        [self foundBarcode:barcode corners:readableMetadataObj.corners];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [_captureSession startRunning];
}


#pragma mark - Helpers

- (BPScanCodeView *)castView {
    return (BPScanCodeView *) self.view;
}

#pragma mark - BPStackViewDelegate

- (void)willAddCard:(BPCardView *)cardView withAnimationDuration:(CGFloat)animationDuration {

}

- (void)willEnterFullScreen:(BPCardView *)cardView withAnimationDuration:(CGFloat)animationDuration {
    self.addingCardEnabled = NO;
}

- (void)didExitFullScreen:(BPCardView *)cardView {
    self.addingCardEnabled = YES;
}

@end