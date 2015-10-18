//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPReportManager.h"
#import "BPTaskRunner.h"
#import "BPAPIAccessor.h"
#import "BPAPIAccessor+BPReport.h"
#import "BPTask.h"
#import "BPReport.h"
#import "BPReportResult.h"

@interface BPReportManager ()

@property(nonatomic, readonly) BPTaskRunner *taskRunner;
@property(nonatomic, readonly) BPAPIAccessor *apiAccessor;

@end

@implementation BPReportManager

- (void)sendReport:(BPReport *)report completion:(void (^)(BPReportResult *, NSError *))completion completionQueue:(NSOperationQueue *)completionQueue {
    __block NSError *error;

    weakify()
    void (^block)() = ^{
        strongify()

        NSDictionary *result = [strongSelf.apiAccessor addReport:report.barcode description:report.desc error:&error];

        if (error) {
            BPLog(@"Error while adding report : %@ %@", report.barcode, error.localizedDescription);
            [completionQueue addOperationWithBlock:^{
                completion([BPReportResult resultWithSuccess:NO state:REPORT_STATE_ADDED report:report imageDownloadedIndex:0], error);
            }];
            return;
        }
        NSNumber *reportId = result[@"id"];
        report.id = reportId;

        [completionQueue addOperationWithBlock:^{
            completion([BPReportResult resultWithSuccess:YES state:REPORT_STATE_ADDED report:report imageDownloadedIndex:0], error);
        }];

        [strongSelf sendImagesForReport:report];
    };
    BPTask *task = [BPTask taskWithlock:block completion:nil];
    [self.taskRunner runImmediateTask:task];
}

- (void)sendImagesForReport:(BPReport *)report completion:(void (^)(NSError *))completion completionQueue:(NSOperationQueue *)completionQueue {

}

- (void)sendImageAtPath:(NSString *)imageAtPath forReportId:(NSNumber *)reportId completion:(void (^)(NSError *))completion completionQueue:(NSOperationQueue *)completionQueue {
    __block NSError *error;

    weakify()
    void (^block)() = ^{
        strongify()

        NSDictionary *result = [strongSelf.apiAccessor addReport:report.barcode description:report.desc error:&error];

        if (error) {
            BPLog(@"Error while adding report : %@ %@", report.barcode, error.localizedDescription);
            [completionQueue addOperationWithBlock:^{
                completion([BPReportResult resultWithSuccess:NO state:REPORT_STATE_ADDED report:report imageDownloadedIndex:0], error);
            }];
            return;
        }
        NSNumber *reportId = result[@"id"];
        report.id = reportId;

        [completionQueue addOperationWithBlock:^{
            completion([BPReportResult resultWithSuccess:YES state:REPORT_STATE_ADDED report:report imageDownloadedIndex:0], error);
        }];

        [strongSelf sendImagesForReport:report];
    };
    BPTask *task = [BPTask taskWithlock:block completion:nil];
    [self.taskRunner runImmediateTask:task];
}

@end