#import "BPProductImageManager.h"
#import "UIImage+Scaling.h"

const float SMALL_IMAGE_WIDTH = 200;
const float LARGE_IMAGE_WIDTH = 800;

@implementation BPProductImageManager

- (void)saveImage:(UIImage *)image forKey:(NSNumber *)key index:(int)index {
    UIImage *largeImage = [image scaledToWidth:LARGE_IMAGE_WIDTH];
    [UIImagePNGRepresentation(largeImage) writeToFile:[self imagePathForKey:key index:index small:NO] atomically:NO];

    UIImage *smallImage = [image scaledToWidth:SMALL_IMAGE_WIDTH];
    [UIImagePNGRepresentation(smallImage) writeToFile:[self imagePathForKey:key index:index small:YES] atomically:NO];
}

- (void)removeImageforKey:(NSNumber *)key index:(int)index {
    NSFileManager *fileManager = [NSFileManager defaultManager];

    [fileManager removeItemAtPath:[self imagePathForKey:key index:index small:NO] error:nil];
    [fileManager removeItemAtPath:[self imagePathForKey:key index:index small:YES] error:nil];
}

- (BOOL)isImageExistForKey:(NSNumber *)key index:(int)index {
    NSString *imagePath = [self imagePathForKey:key index:index small:YES];
    return [[NSFileManager defaultManager] fileExistsAtPath:imagePath];
}

- (UIImage *)retrieveImageForKey:(NSNumber *)key index:(int)index small:(BOOL)small {
    NSString *imagePath = [self imagePathForKey:key index:index small:small];
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    return [UIImage imageWithData:data];
}

- (NSString *)imagePathForKey:(NSNumber *)key index:(int)index small:(BOOL)small {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directory = paths[0];
    NSString *filename = [NSString stringWithFormat:@"%@_%i_%i", key, index, small];
    return [directory stringByAppendingPathComponent:filename];
}

- (NSArray *)createImagePathArrayForKey:(NSNumber *)key imageCount:(int)imageCount {
    NSMutableArray *pathArray = [NSMutableArray arrayWithCapacity:(NSUInteger)imageCount];
    for (int i = 0; i < imageCount; ++i) {
        NSString *imagePath = [self imagePathForKey:key index:i small:NO];
        [pathArray addObject:imagePath];
    }
    return pathArray;
}

@end
