#import <Foundation/Foundation.h>


@interface BPTask : NSObject

@property (nonatomic, copy) void (^block)(void);
@property (nonatomic, copy) void (^completion)(void);

- (instancetype)initWithBlock:(void (^)())taskBlock completion:(void (^)())completion;
+ (instancetype)taskWithlock:(void (^)())taskBlock completion:(void (^)())completion;

@end