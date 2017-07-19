#import "BPCapturedImageManager.h"
#import "UIImage+Scaling.h"

@implementation BPCapturedImageManager

- (void)saveImageData:(NSData *)imageData captureSessionTimestamp:(int)timestamp index:(int)index {
    NSString *path = [self imagePathForSessionTimestamp:timestamp index:index];
    NSLog(@"save image data with index: %d path: %@", index, path);
    [imageData writeToFile:path atomically:NO];
}

- (NSArray<NSData *> *)retrieveImagesDataForCaptureSessionTimestamp:(int)timestamp imageCount:(int)imageCount {
    NSMutableArray *imagesDataArray = [NSMutableArray arrayWithCapacity:(NSUInteger) imageCount];
    
    for (int i=0; i<imageCount; i++) {
        NSString *path = [self imagePathForSessionTimestamp:timestamp index:i];
        NSLog(@"retrieve image data with index: %d path: %@", i, path);
        [imagesDataArray addObject: [NSData dataWithContentsOfFile:path]];
    }
    
    return imagesDataArray;
}
    

- (void)removeImagesDataForCaptureSessionTimestamp:(int)timestamp imageCount:(int)imageCount {
    for (int i=0; i<imageCount; i++) {
        NSString *path = [self imagePathForSessionTimestamp:timestamp index:i];
        NSLog(@"remove image data with index: %d path: %@", i, path);
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
}

- (NSString *)imagePathForSessionTimestamp:(int)timestamp index:(int)index {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directory = paths[0];
    NSString *filename = [NSString stringWithFormat:@"%d_%d.jpg", timestamp, index];
    return [directory stringByAppendingPathComponent:filename];
}

@end
