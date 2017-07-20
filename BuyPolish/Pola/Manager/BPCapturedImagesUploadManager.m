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

- (void)sendImagesWithData:(BPCapturedImagesData *)imagesData captureSessionTimestamp:(int)timestamp completion:(void (^)(BPCapturedImageResult *, NSError *))completion completionQueue:(NSOperationQueue *)completionQueue {
    __block NSError *error;
    
    weakify()
    void (^block)() = ^{
        strongify()
        
        NSDictionary *result = [strongSelf.apiAccessor addAiPicsWithCapturedImagesData:imagesData error:&error];
        
        if (error) {
            [completionQueue addOperationWithBlock:^{
                completion([[BPCapturedImageResult alloc] initWithState:CAPTURED_IMAGE_STATE_ADDING capturedImagesData:imagesData imageIndex:-1], error);
            }];
            return;
        }
        
        NSArray *signedRequestArray = result[@"signed_requests"];
        
        [completionQueue addOperationWithBlock:^{
            completion([[BPCapturedImageResult alloc] initWithState:CAPTURED_IMAGE_STATE_ADDING capturedImagesData:imagesData imageIndex:-1], error);
        }];

        int imageCount = (int)imagesData.filesCount.integerValue;
        NSArray<NSData *> *imageDataArray = [strongSelf.imageManager retrieveImagesDataForCaptureSessionTimestamp:timestamp imageCount:imageCount];
        
        for (int i=0; i<imageCount; i++) {
            [strongSelf uploadImageData:imageDataArray[i] toUrl:signedRequestArray[i] mimeType:imagesData.mimeType completion:^(NSError *imageUploadError) {
                [completionQueue addOperationWithBlock:^{
                    if (imageUploadError) {
                        completion([[BPCapturedImageResult alloc] initWithState:CAPTURED_IMAGE_STATE_UPLOADING capturedImagesData:imagesData imageIndex:i], imageUploadError);
                    } else {
                        completion([[BPCapturedImageResult alloc] initWithState:CAPTURED_IMAGE_STATE_FINISHED capturedImagesData:imagesData imageIndex:i], imageUploadError);
                    }
                }];
            }];
        }
    };
    BPTask *task = [BPTask taskWithlock:block completion:nil];
    [self.taskRunner runImmediateTask:task];

}    

- (void)uploadImageData:(NSData *)imageData toUrl:(NSString *)uploadUrl mimeType:(NSString *)mimeType completion:(void (^)(NSError *))completion {
    __block NSError *error;
    
    weakify()
    void (^block)() = ^{
        strongify()
        [strongSelf.apiAccessor uploadImage:imageData toUrl:uploadUrl mimeType:mimeType error:&error];
        completion(error);
    };
    BPTask *task = [BPTask taskWithlock:block completion:nil];
    [self.taskRunner runImmediateTask:task];
}

@end
