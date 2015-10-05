#import <Objection/Objection.h>
#import "BPScanCodeViewController.h"
#import "BPScanCodeView.h"
#import "BPProductManager.h"
#import "BPProduct.h"
#import "BPTaskRunner.h"
#import "BPActivityIndicatorView.h"
#import "UIAlertView+BPUtilities.h"
#import "NSString+BPUtilities.h"
#import "BPProduct+Utilities.h"
#import "BPStackView.h"
#import "BPCardView.h"


@interface BPScanCodeViewController ()

@property(nonatomic, strong) AVCaptureSession *captureSession;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, readonly) BPTaskRunner *taskRunner;
@property(nonatomic, readonly) BPProductManager *productManager;
@property(nonatomic, strong) NSString *lastBardcodeScanned;

@end


@implementation BPScanCodeViewController

objection_requires_sel(@selector(taskRunner), @selector(productManager))

- (void)loadView {
    self.view = [[BPScanCodeView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.castView.stackView.delegate = self;

    [self setupCaptureSession];

    self.title = NSLocalizedString(@"Scan Code", @"");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupVideoLayer];
    [_captureSession startRunning];
}

#pragma mark - Actions

- (void)foundBarcode:(NSString *)barcode corners:(NSArray *)corners {
    if(![barcode isValidBarcode]) {
        [self.captureSession startRunning];

        UIAlertView * alertView = [UIAlertView showErrorAlert:NSLocalizedString(@"Not valid barcode. Please try again.", @"Not valid barcode. Please try again.")];
        [alertView setDelegate:self];
        return;
    }

    if([barcode isEqualToString:self.lastBardcodeScanned]) {
        return;
    }

    BPProduct *product = [[BPProduct alloc] initWithBarcode:barcode];
    [product fillMadeInPolandFromBarcode:barcode];

    if([self addCardAndDownloadDetails:product]) {
        self.lastBardcodeScanned = barcode;
    }
}

- (BOOL)addCardAndDownloadDetails:(BPProduct *)product {
    BPCardView *cardView = [[BPCardView alloc] initWithFrame:CGRectZero];
    cardView.madeInPoland = product.madeInPoland;
    cardView.inProgress = YES;
    cardView.barcode = product.barcode;
    BOOL cardAdded = [self.castView.stackView addCard:cardView];
    if(!cardAdded) {
        return NO;
    }

    [self.productManager retrieveProductWithBarcode:product.barcode completion:^(BPProduct *fetchedProduct, NSError *error) {
        if(!error) {
            cardView.inProgress = NO;
            //todo update cardview
        } else {
            [UIAlertView showErrorAlert:NSLocalizedString(@"Cannot fetch product info from server. Please try again.", @"")];
        }
    } completionQueue:[NSOperationQueue mainQueue]];

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

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        NSObject *metadataObj = metadataObjects.firstObject;
        if(![metadataObj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
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
    [self.castView changeVideoLayerHeightWithAnimationDuration:animationDuration];
}

- (void)willEnterFullScreen:(BPCardView *)cardView withAnimationDuration:(CGFloat)animationDuration {
    [self.captureSession stopRunning];
}

- (void)willExitFullScreen:(BPCardView *)cardView withAnimationDuration:(CGFloat)animationDuration {
    [self.captureSession startRunning];
}


@end