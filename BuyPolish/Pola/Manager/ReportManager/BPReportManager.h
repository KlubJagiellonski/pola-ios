#import "BPAPIAccessor.h"
#import "BPReport.h"
#import "BPReportResult.h"
#import "BPTaskRunner.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPReportManager : NSObject

@property (nonatomic) BPTaskRunner *taskRunner;
@property (nonatomic) BPAPIAccessor *apiAccessor;

- (void)sendReport:(BPReport *)report
         completion:(void (^)(BPReportResult *_Nullable, NSError *_Nullable))completion
    completionQueue:(NSOperationQueue *)completionQueue;
@end

NS_ASSUME_NONNULL_END
