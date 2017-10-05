#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@protocol BPImageRecognitionManagerDelegate <NSObject>

- (void)imageRecognitionManagerCandidateLabels:(NSArray<NSString *> *)labels withPredictionValues:(NSArray<NSNumber *> *)values;

@end

@interface BPImageRecognitionManager : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (weak, nonatomic) id<BPImageRecognitionManagerDelegate> delegate;

- (void)setupWithCaptureSession:(AVCaptureSession *)session;

@end
