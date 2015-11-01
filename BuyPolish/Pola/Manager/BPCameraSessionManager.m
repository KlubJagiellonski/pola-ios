//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Objection/Objection.h>
#import "BPCameraSessionManager.h"
#import "BPProductImageManager.h"


@interface BPCameraSessionManager ()
@property(nonatomic, readonly) BPProductImageManager *imageManager;
@end

@implementation BPCameraSessionManager
objection_requires_sel(@selector(imageManager))

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupCaptureSession];
        [self setupVideoLayer];
    }

    return self;
}

- (void)setupCaptureSession {
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];

    if (input) {
        _captureSession = [[AVCaptureSession alloc] init];
        [self.captureSession addInput:input];
        AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.captureSession addOutput:captureMetadataOutput];

        [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code]];
    }
}

- (void)setupVideoLayer {
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}


- (void)start {
    [self.captureSession startRunning];
}

- (void)stop {
    [self.captureSession stopRunning];
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
        [self.delegate didFindBarcode:barcode];
    }
}


@end