#import <Objection/Objection.h>
#import "BPCaptureVideoManager.h"

@interface BPCaptureVideoManager ()
@property(nonatomic) AVCaptureVideoDataOutput *videoDataOutput;
@property(nonatomic) dispatch_queue_t videoDataOutputQueue;
@property(nonatomic) BOOL wantsCaptureImage;
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
    _wantsCaptureImage = NO;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (input) {
        _captureSession = [[AVCaptureSession alloc] init];
        [_captureSession addInput:input];
        
        _videoDataOutput = [AVCaptureVideoDataOutput new];
        
        NSDictionary *rgbOutputSettings = [NSDictionary
                                           dictionaryWithObject:[NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                           forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        [_videoDataOutput setVideoSettings:rgbOutputSettings];
        [_videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
        _videoDataOutputQueue =
        dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
        [_videoDataOutput setSampleBufferDelegate:self queue:_videoDataOutputQueue];
        
        if ([_captureSession canAddOutput:_videoDataOutput])
            [_captureSession addOutput:_videoDataOutput];
        [[_videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
        
        self.captureSession.sessionPreset = AVCaptureSessionPresetPhoto;
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
        CGImageRef myImage = [context createCGImage:ciImage fromRect:CGRectMake(0, 0, CVPixelBufferGetWidth(pixelBuffer), CVPixelBufferGetHeight(pixelBuffer))];
        UIImage *uiImage = [UIImage imageWithCGImage:myImage];
        [self.delegate captureVideoManager:self didCaptureImage:uiImage];
    }
}

@end
