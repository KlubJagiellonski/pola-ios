#import <Foundation/Foundation.h>

@class BPReport;
@class BPReportResult;


@interface BPReportManager : NSObject
- (void)sendReport:(BPReport *)report completion:(void (^)(BPReportResult *, NSError *))completion completionQueue:(NSOperationQueue *)completionQueue;
@end