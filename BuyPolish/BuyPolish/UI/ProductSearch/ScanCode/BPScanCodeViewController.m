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


@interface BPScanCodeViewController ()

@property(nonatomic, strong) AVCaptureSession *captureSession;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, readonly) BPTaskRunner *taskRunner;

@end


@implementation BPScanCodeViewController

objection_requires_sel(@selector(taskRunner))

- (void)loadView {
    self.view = [[BPScanCodeView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupCaptureSession];

    self.title = NSLocalizedString(@"Scan Code", @"");
//        self.tabBarItem = [[UITabBarItem alloc] init
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupVideoLayer];
    [_captureSession startRunning];
}

#pragma mark - Actions

- (void)foundBarcode:(NSString *)barcode corners:(NSArray *)corners {
    [self.captureSession stopRunning];

    if(![barcode isValidBarcode]) {
        UIAlertView * alertView = [UIAlertView showErrorAlert:NSLocalizedString(@"Not valid barcode. Please try again.", @"Not valid barcode. Please try again.")];
        [alertView setDelegate:self];
        return;
    }

    BPProduct *product = [[BPProduct alloc] initWithBarcode:barcode];
    [product fillMadeInPolandFromBarcode:barcode];
    [self.delegate scanCode:self requestsProductInfo:product];
}

#pragma mark - Capture session

- (void)setupVideoLayer {
    if (_captureSession) {
        _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [_videoPreviewLayer setFrame:self.view.layer.bounds];
        [self.view.layer addSublayer:_videoPreviewLayer];
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
        [captureMetadataOutput setMetadataObjectTypes:captureMetadataOutput.availableMetadataObjectTypes];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = metadataObjects.firstObject;

        NSString *barcode = metadataObj.stringValue;
        BPLog(@"Found barcode: %@", barcode);
        [self foundBarcode:barcode corners:metadataObj.corners];
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

@end