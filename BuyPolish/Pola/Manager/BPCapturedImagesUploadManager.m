#import "BPCapturedImagesUploadManager.h"
#import "BPAPIAccessor+BPCapturedImagesData.h"
#import "BPTaskRunner.h"
#import "BPTask.h"

@import Objection;

@interface BPCapturedImagesUploadManager ()

@property(nonatomic) BPTaskRunner *taskRunner;
@property(nonatomic, readonly) BPAPIAccessor *apiAccessor;
@property(nonatomic, readonly) BPCapturedImageManager *imageManager;
@property(nonatomic) UIBackgroundTaskIdentifier backgroundTaskIdentifier;

@end

@implementation BPCapturedImagesUploadManager

objection_requires_sel(@selector(taskRunner), @selector(apiAccessor), @selector(imageManager))

- (void)sendImagesWithData:(BPCapturedImagesData *)imagesData
   captureSessionTimestamp:(int)timestamp
                  progress:(void (^)(BPCapturedImageResult *, NSError *))progress
                completion:(void (^)(NSError *))completion
             dispatchQueue:(NSOperationQueue *)dispatchQueue {
    
    [self beginBackgroundUpdateTaskForTimestamp:timestamp imagesCount:imagesData.filesCount.intValue];
    
    __block NSError *error;
    
    weakify()
    void (^onCompletion)(NSError *) = ^void(NSError *error) {
        strongify();
        
        if (error) {
            [strongSelf.imageManager removeImagesDataForCaptureSessionTimestamp:timestamp imageCount:imagesData.filesCount.intValue];
        }
        
        completion(error);
        [strongSelf endBackgroundUpdateTastForTimestamp:timestamp imagesCount:imagesData.filesCount.intValue];
    };
    
    void (^block)() = ^{
        strongify()
        
        NSDictionary *result = [strongSelf.apiAccessor addAiPicsWithCapturedImagesData:imagesData error:&error];
        
        if (error) {
            [dispatchQueue addOperationWithBlock:^{
                progress([[BPCapturedImageResult alloc] initWithState:CAPTURED_IMAGE_STATE_ADDING capturedImagesData:imagesData imageIndex:-1], error);
                onCompletion(error);
            }];
            return;
        }
        
        NSArray *signedRequestArray = result[@"signed_requests"];
        
        [dispatchQueue addOperationWithBlock:^{
            progress([[BPCapturedImageResult alloc] initWithState:CAPTURED_IMAGE_STATE_ADDING capturedImagesData:imagesData imageIndex:-1], error);
        }];

        int imageCount = (int)imagesData.filesCount.integerValue;
        NSArray<NSData *> *imageDataArray = [strongSelf.imageManager retrieveImagesDataForCaptureSessionTimestamp:timestamp imageCount:imageCount];
        
        __block int amountOfFinishedUploads = 0;
        for (int i=0; i<imageCount; i++) {
            [strongSelf uploadImageData:imageDataArray[i] toUrl:signedRequestArray[i] mimeType:imagesData.mimeType completion:^(NSError *imageUploadError) {
                [dispatchQueue addOperationWithBlock:^{
                    if (imageUploadError) {
                        progress([[BPCapturedImageResult alloc] initWithState:CAPTURED_IMAGE_STATE_UPLOADING capturedImagesData:imagesData imageIndex:i], imageUploadError);
                    } else {
                        progress([[BPCapturedImageResult alloc] initWithState:CAPTURED_IMAGE_STATE_FINISHED capturedImagesData:imagesData imageIndex:i], imageUploadError);
                    }
                    [self.imageManager removeImageDataForCaptureSessionTimestamp:timestamp imageIndex:i];
                    
                    amountOfFinishedUploads++;
                    if (amountOfFinishedUploads == imageCount) {
                        onCompletion(NULL);
                    }
                }];
            }];
        }
    };
    BPTask *task = [BPTask taskWithBlock:block completion:nil];
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
    BPTask *task = [BPTask taskWithBlock:block completion:nil];
    [self.taskRunner runImmediateTask:task];
}

#pragma mark - Background task

- (void)beginBackgroundUpdateTaskForTimestamp:(int)timestamp imagesCount:(int)imagesCount {
    weakify()
    self.backgroundTaskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        strongify()
        [strongSelf endBackgroundUpdateTastForTimestamp:timestamp imagesCount:imagesCount];
    }];
}

- (void)endBackgroundUpdateTastForTimestamp:(int)timestamp imagesCount:(int)imagesCount {
    if (self.backgroundTaskIdentifier != UIBackgroundTaskInvalid) {
        [self.imageManager removeImagesDataForCaptureSessionTimestamp:timestamp imageCount:imagesCount];
        [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTaskIdentifier];
        
        self.backgroundTaskIdentifier = UIBackgroundTaskInvalid;
    }
}

@end
