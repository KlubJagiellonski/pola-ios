#import <Foundation/Foundation.h>

@interface BPTask : NSObject

@property (copy, nonatomic) void (^block)(void);
@property (copy, nonatomic) void (^completion)(void);

- (instancetype)initWithBlock:(void (^)())taskBlock completion:(void (^)())completion;
+ (instancetype)taskWithBlock:(void (^)())taskBlock completion:(void (^)())completion;

@end
