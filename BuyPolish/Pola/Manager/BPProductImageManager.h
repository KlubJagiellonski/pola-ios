#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPProductImageManager : NSObject

- (void)saveImage:(UIImage *)image forKey:(nullable NSNumber *)key index:(int)index;

- (void)removeImageforKey:(nullable NSNumber *)key index:(int)index;

- (BOOL)isImageExistForKey:(nullable NSNumber *)key index:(int)index;

- (UIImage *)retrieveImageForKey:(nullable NSNumber *)key index:(int)index small:(BOOL)small;

- (NSArray<NSString *> *)createImagePathArrayForKey:(nullable NSNumber *)key imageCount:(int)imageCount;

@end

NS_ASSUME_NONNULL_END
