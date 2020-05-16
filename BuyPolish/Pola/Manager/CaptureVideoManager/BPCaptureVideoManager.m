#import "BPCaptureVideoManager.h"

@import Objection;

@interface BPCaptureVideoManager ()
@property (nonatomic) dispatch_queue_t videoDataOutputQueue;
@property (nonatomic) BOOL wantsCaptureImage;
@end

@implementation BPCaptureVideoManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        [self setupCaptureSession];
        [self setupVideoLayer];
    }

    return self;
}

- (void)setupCaptureSession {
    _wantsCaptureImage = NO;

    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];

    if (input) {
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession addInput:input];

        AVCaptureVideoDataOutput *videoDataOutput = [self createVideoDataOutput];

        if ([_captureSession canAddOutput:videoDataOutput]) {
            [_captureSession addOutput:videoDataOutput];
        }

        AVCaptureConnection *connection = [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
        [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
        [connection setEnabled:YES];

        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
    }
}

- (AVCaptureVideoDataOutput *)createVideoDataOutput {
    AVCaptureVideoDataOutput *videoDataOutput = [AVCaptureVideoDataOutput new];

    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                                                  forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    [videoDataOutput setSampleBufferDelegate:self queue:_videoDataOutputQueue];
    return videoDataOutput;
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

- (void)requestCaptureImage {
    self.wantsCaptureImage = YES;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
           fromConnection:(AVCaptureConnection *)connection {
    if (self.wantsCaptureImage) {
        self.wantsCaptureImage = NO;
        CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
        CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef myImage = [context
            createCGImage:ciImage
                 fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];
        UIImage *uiImage = [UIImage imageWithCGImage:myImage];

        weakify();
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            strongify();
            [strongSelf.delegate captureVideoManager:strongSelf didCaptureImage:uiImage];
        }];
    }
}

@end
