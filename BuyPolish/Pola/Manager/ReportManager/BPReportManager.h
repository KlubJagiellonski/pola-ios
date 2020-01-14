#import "BPAPIAccessor.h"
#import "BPTaskRunner.h"
#import <Foundation/Foundation.h>

@class BPReport;
@class BPReportResult;

NS_ASSUME_NONNULL_BEGIN

@interface BPReportManager : NSObject

@property (nonatomic) BPTaskRunner *taskRunner;
@property (nonatomic) BPAPIAccessor *apiAccessor;

- (void)sendReport:(BPReport *)report
         completion:(void (^)(BPReportResult *, NSError *))completion
    completionQueue:(NSOperationQueue *)completionQueue;
@end

NS_ASSUME_NONNULL_END
