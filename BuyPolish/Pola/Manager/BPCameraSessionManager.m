//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <Objection/Objection.h>
#import "BPCameraSessionManager.h"
#import "BPProductImageManager.h"


@interface BPCameraSessionManager ()
@property(nonatomic, readonly) AVCaptureStillImageOutput *stillImageOutput;
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

        _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        [self.stillImageOutput setOutputSettings:@{AVVideoCodecKey : AVVideoCodecJPEG}];
        [self.captureSession addOutput:self.stillImageOutput];

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

- (void)captureImageForBarcode:(NSString *)barcode {
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in self.stillImageOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo]) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {break;}
    }

    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error) {
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
        [self.imageManager saveImage:imageData forBarcode:barcode index:0];
    }];
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