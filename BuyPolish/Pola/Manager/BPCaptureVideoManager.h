#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVCaptureSession;
@class AVCaptureVideoPreviewLayer;
@class BPCaptureVideoManager;

@protocol BPCaptureVideoManagerDelegate <NSObject>
- (void)captureVideoManager:(BPCaptureVideoManager *)captureManager didCaptureImage:(UIImage *)image;
@end

@interface BPCaptureVideoManager : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, readonly) AVCaptureSession *captureSession;
@property(nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(weak, nonatomic) id <BPCaptureVideoManagerDelegate> delegate;

- (void)startCameraPreview;

- (void)stopCameraPreview;

- (void)requestCaptureImage;

@end
