#import <Foundation/Foundation.h>

@interface BPCapturedImageManager : NSObject

- (void)saveImageData:(NSData *)imageData captureSessionTimestamp:(int)timestamp index:(int)index;
- (NSArray<NSData *> *)retrieveImagesDataForCaptureSessionTimestamp:(int)timestamp imageCount:(int)imageCount;
- (void)removeImagesDataForCaptureSessionTimestamp:(int)timestamp imageCount:(int)imageCount;
- (void)removeImageDataForCaptureSessionTimestamp:(int)timestamp imageIndex:(int)index;

@end
