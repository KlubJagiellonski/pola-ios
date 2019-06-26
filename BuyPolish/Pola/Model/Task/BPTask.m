#import "BPTask.h"

@implementation BPTask

- (instancetype)initWithBlock:(void (^)())taskBlock completion:(void (^)())completion {
    self = [super init];
    if (self) {
        _block = taskBlock;
        _completion = completion;
    }

    return self;
}

+ (instancetype)taskWithlock:(void (^)())taskBlock completion:(void (^)())completion {
    return [[self alloc] initWithBlock:taskBlock completion:completion];
}

@end
