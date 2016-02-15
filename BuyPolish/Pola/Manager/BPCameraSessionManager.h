#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AVCaptureSession;
@class AVCaptureVideoPreviewLayer;


@protocol BPCameraSessionManagerDelegate <NSObject>

- (void)didFindBarcode:(NSString *)barcode;

@end


@interface BPCameraSessionManager : NSObject <AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, strong, readonly) AVCaptureSession *captureSession;
@property(nonatomic, strong, readonly) AVCaptureVideoPreviewLayer *videoPreviewLayer;
@property(nonatomic, weak) id <BPCameraSessionManagerDelegate> delegate;

- (void)start;

- (void)stop;

@end