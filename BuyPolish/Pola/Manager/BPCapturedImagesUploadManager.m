#import <Objection/Objection.h>
#import "BPCapturedImagesUploadManager.h"
#import "BPAPIAccessor+BPCapturedImagesData.h"
#import "BPTaskRunner.h"
#import "BPTask.h"

@interface BPCapturedImagesUploadManager ()

@property(nonatomic) BPTaskRunner *taskRunner;
@property(nonatomic, readonly) BPAPIAccessor *apiAccessor;
@property(nonatomic, readonly) BPCapturedImageManager *imageManager;

@end

@implementation BPCapturedImagesUploadManager

objection_requires_sel(@selector(taskRunner), @selector(apiAccessor), @selector(imageManager))

- (void)sendImagesWithData:(BPCapturedImagesData *)imagesData captureSessionTimestamp:(int)timestamp singleUploadCompletion:(void (^)(NSError *))completion completionQueue:(NSOperationQueue *)completionQueue {
    __block NSError *error;
    
    weakify()
    void (^block)() = ^{
        strongify()
        
        NSDictionary *result = [strongSelf.apiAccessor addAiPicsWithCapturedImagesData:imagesData error:&error];
        
        if (error) {
            BPLog(@"Error while adding ai pictures for productID: %@, %@", imagesData.productID, error.localizedDescription);
            [completionQueue addOperationWithBlock:^{
                //completion([BPReportResult resultWithState:REPORT_STATE_ADD report:report imageDownloadedIndex:0], error);
            }];
            return;
        }
        
        BPLog(@"add ai pictures result: %@", result);
        
        NSArray *signedRequestArray = result[@"signed_requests"];
        
        [completionQueue addOperationWithBlock:^{
            //completion([BPReportResult resultWithState:REPORT_STATE_ADD report:report imageDownloadedIndex:0], error);
        }];
        
//        if (report.imagePathArray.count == 0) {
//            completion([BPReportResult resultWithState:REPORT_STATE_FINSIHED report:report imageDownloadedIndex:0], error);
//            return;
//        }
        
        // TODO:check if any image with timestamp exist before retrieving it for each index

        int imageCount = (int)imagesData.filesCount.integerValue;
        NSArray<NSData *> *imageDataArray = [strongSelf.imageManager retrieveImagesDataForCaptureSessionTimestamp:timestamp imageCount:imageCount];
        
        for (int i=0; i<imageCount; i++) {
            [strongSelf uploadImageData:imageDataArray[i] toUrl:signedRequestArray[i] completion:^(NSError *imageUploadError) {
                [completionQueue addOperationWithBlock:^{
                    if (imageUploadError) {
                        BPLog(@"Error while uploading ai pictures for productID: %@, imageIndex: %d, uploadUrl: %@, error: %@", imagesData.productID, i, signedRequestArray[i], error.localizedDescription);
                        //completion([BPReportResult resultWithState:REPORT_STATE_IMAGE_ADD report:report imageDownloadedIndex:(int) index], sendImageError);
                    } else {
                        //completion([BPReportResult resultWithState:REPORT_STATE_FINSIHED report:report imageDownloadedIndex:(int) index], sendImageError);
                    }
                }];
            }];
        }
    };
    BPTask *task = [BPTask taskWithlock:block completion:nil];
    [self.taskRunner runImmediateTask:task];

}    

- (void)uploadImageData:(NSData *)imageData toUrl:(NSString *)uploadUrl completion:(void (^)(NSError *))completion {
    __block NSError *error;
    
    weakify()
    void (^block)() = ^{
        strongify()
        
        [strongSelf.apiAccessor uploadImage:imageData toUrl:uploadUrl error:&error];
        
        if (error) {
            BPLog(@"Error while uploading captured image, uploadUrl: %@", uploadUrl);
        }
        
        completion(error);
    };
    BPTask *task = [BPTask taskWithlock:block completion:nil];
    [self.taskRunner runImmediateTask:task];
}

@end
