#import "BPImmediateTask.h"


@implementation BPImmediateTask

- (instancetype)initWithBlock:(void (^)())taskBlock completion:(void (^)())completion {
    self = [super initWithBlock:taskBlock completion:completion];
    if (self) {
        _operation.queuePriority = NSOperationQueuePriorityVeryHigh;
    }

    return self;
}


@end