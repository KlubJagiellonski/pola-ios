#import "BPCapturedImagesData.h"
#import <Foundation/Foundation.h>

extern const int CAPTURED_IMAGE_STATE_ADDING;
extern const int CAPTURED_IMAGE_STATE_UPLOADING;
extern const int CAPTURED_IMAGE_STATE_FINISHED;

@interface BPCapturedImageResult : NSObject

@property (nonatomic) int state;
@property (nonatomic) BPCapturedImagesData *imagesData;
@property (nonatomic) int imageIndex;

- (instancetype)initWithState:(int)state
           capturedImagesData:(BPCapturedImagesData *)imagesData
                   imageIndex:(int)imageIndex;

@end
