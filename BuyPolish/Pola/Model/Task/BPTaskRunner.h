#import <Foundation/Foundation.h>

@class BPTask;

@interface BPTaskRunner : NSObject

- (void)runInMainQueue:(void (^)(void))block;
- (void)runTask:(BPTask *)task;
- (void)runImmediateTask:(BPTask *)task;

@end
