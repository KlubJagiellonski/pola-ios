//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Objection/Objection.h>
#import "BPReportManager.h"
#import "BPTaskRunner.h"
#import "BPAPIAccessor.h"
#import "BPAPIAccessor+BPReport.h"
#import "BPReport.h"
#import "BPTask.h"
#import "BPReportResult.h"

@interface BPReportManager ()

@property(nonatomic) BPTaskRunner *taskRunner;
@property(nonatomic) BPAPIAccessor *apiAccessor;

@end

@implementation BPReportManager

objection_requires_sel(@selector(taskRunner), @selector(apiAccessor))

- (void)sendReport:(BPReport *)report completion:(void (^)(BPReportResult *, NSError *))completion completionQueue:(NSOperationQueue *)completionQueue {
    __block NSError *error;

    weakify()
    void (^block)() = ^{
        strongify()

        NSDictionary *result = [strongSelf.apiAccessor addReport:report.barcode description:report.desc error:&error];

        if (error) {
            BPLog(@"Error while adding report : %@ %@", report.barcode, error.localizedDescription);
            [completionQueue addOperationWithBlock:^{
                completion([BPReportResult resultWithState:REPORT_STATE_ADD report:report imageDownloadedIndex:0], error);
            }];
            return;
        }
        NSNumber *reportId = result[@"id"];
        report.id = reportId;

        [completionQueue addOperationWithBlock:^{
            completion([BPReportResult resultWithState:REPORT_STATE_ADD report:report imageDownloadedIndex:0], error);
        }];

        [self sendImagesForImagePath:report.imagePathArray reportId:reportId index:0 completion:^(NSUInteger index, NSError *sendImageError) {
            [completionQueue addOperationWithBlock:^{
                if (sendImageError) {
                    BPLog(@"Error while adding images: %@ %@", report.barcode, error.localizedDescription);
                    completion([BPReportResult resultWithState:REPORT_STATE_IMAGE_ADD report:report imageDownloadedIndex:index], sendImageError);
                } else {
                    completion([BPReportResult resultWithState:REPORT_STATE_FINSIHED report:report imageDownloadedIndex:index], sendImageError);
                }
            }];
        }];
    };
    BPTask *task = [BPTask taskWithlock:block completion:nil];
    [self.taskRunner runImmediateTask:task];
}

- (void)sendImagesForImagePath:(NSArray *)imagePathArray reportId:(NSNumber *)reportId index:(NSUInteger)index completion:(void (^)(NSUInteger, NSError *))completion {
    weakify()
    void (^block)() = ^{
        strongify()

        NSString *imagePath = imagePathArray[index];
        [strongSelf sendImageAtPath:imagePath forReportId:reportId completion:^(NSError *error) {
            if (error) {
                completion(index, error);
            } else {
                NSUInteger nextIndex = index + 1;
                if (imagePathArray.count == nextIndex) {
                    completion(index, nil);
                } else {
                    [self sendImagesForImagePath:imagePathArray reportId:reportId index:nextIndex completion:completion];
                }
            }
        }];
    };

    BPTask *task = [BPTask taskWithlock:block completion:nil];
    [self.taskRunner runImmediateTask:task];
}

- (void)sendImageAtPath:(NSString *)imageAtPath forReportId:(NSNumber *)reportId completion:(void (^)(NSError *))completion {
    __block NSError *error;

    weakify()
    void (^block)() = ^{
        strongify()

        [strongSelf.apiAccessor addImageAtPath:imageAtPath forReportId:reportId error:&error];

        if (error) {
            BPLog(@"Error while adding image : %@ %@ %@", imageAtPath, reportId, error.localizedDescription);
        }

        completion(error);
    };
    BPTask *task = [BPTask taskWithlock:block completion:nil];
    [self.taskRunner runImmediateTask:task];
}

@end