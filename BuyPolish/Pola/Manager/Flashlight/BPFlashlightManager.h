#import <Foundation/Foundation.h>

@interface BPFlashlightManager : NSObject

@property (nonatomic, readonly) BOOL isAvailable;
@property (nonatomic, readonly) BOOL isOn;

- (void)toggleWithCompletionBlock:(void (^)(BOOL success))completion;

@end
