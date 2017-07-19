#import <Objection/Objection.h>
#import "BPCaptureVideoManager.h"
#import "BPProductImageManager.h"


@interface BPCaptureVideoManager ()
@property(nonatomic) AVCaptureStillImageOutput *stillCameraOutput;
@property(nonatomic) dispatch_queue_t captureSessionQueue;  // TODO: check proper way to reference dispatch queue
@end

@implementation BPCaptureVideoManager

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
        
        self.stillCameraOutput = [[AVCaptureStillImageOutput alloc] init];
        [self.captureSession addOutput:self.stillCameraOutput];
        
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        
        self.captureSessionQueue = dispatch_queue_create("com.example.camera.capture_session", DISPATCH_QUEUE_SERIAL);
    }
}

- (void)setupVideoLayer {
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
}


- (void)startCameraPreview {
    [self.captureSession startRunning];
}

- (void)stopCameraPreview {
    [self.captureSession stopRunning];
}

- (void)captureImageWithCompletion:(void (^)(UIImage*, NSError*))completion {
    
    dispatch_async(self.captureSessionQueue, ^{        
        AVCaptureConnection *connection = [self.stillCameraOutput connectionWithMediaType:AVMediaTypeVideo];
        connection.videoOrientation = (AVCaptureVideoOrientation) UIDevice.currentDevice.orientation;
        
        [self.stillCameraOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
            if (error == nil) {
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [[UIImage alloc] initWithData:imageData];
                completion(image, nil);
            } else {
                completion(nil, error);
            }
        }];
    });
}

@end
