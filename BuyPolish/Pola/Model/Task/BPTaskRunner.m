#import "BPTaskRunner.h"
#import "BPTask.h"


@interface BPTaskRunner ()

@property(nonatomic, readonly) NSOperationQueue *mainOperationQueue;

@end


@implementation BPTaskRunner

- (id)init {
    self = [super init];
    if (self) {
        _mainOperationQueue = [[NSOperationQueue alloc] init];
    }

    return self;
}

- (void)runInMainQueue:(void (^)(void))block {
    [[NSOperationQueue mainQueue] addOperationWithBlock:block];
}

- (void)runTask:(BPTask *)task {
    [self runTask:task withPriority:NSOperationQueuePriorityNormal];
}

- (void)runImmediateTask:(BPTask *)task {
    [self runTask:task withPriority:NSOperationQueuePriorityVeryHigh];
}

- (void)runTask:(BPTask *)task withPriority:(enum NSOperationQueuePriority)priority {
    NSOperation *operation = [NSBlockOperation blockOperationWithBlock:task.block];
    operation.completionBlock = task.completion;
    operation.queuePriority = priority;
    [self.mainOperationQueue addOperation:operation];
}

@end