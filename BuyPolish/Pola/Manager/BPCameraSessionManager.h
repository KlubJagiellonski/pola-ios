#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVCaptureSession;
@class AVCaptureVideoPreviewLayer;

@protocol BPCameraSessionManagerDelegate <NSObject>

- (void)didFindBarcode:(NSString *)barcode;

@end

@interface BPCameraSessionManager : NSObject <AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, readonly) AVCaptureSession *captureSession;
@property(nonatomic, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(weak, nonatomic) id <BPCameraSessionManagerDelegate> delegate;

- (void)start;

- (void)stop;

@end
