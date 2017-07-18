#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVCaptureSession;
@class AVCaptureVideoPreviewLayer;

@interface BPCaptureVideoManager : NSObject <AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, readonly) AVCaptureSession *captureSession;
@property(nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;

- (void)startCameraPreview;

- (void)stopCameraPreview;

- (void)captureImageWithCompletion:(void (^)(UIImage*, NSError*))completion;

@end
