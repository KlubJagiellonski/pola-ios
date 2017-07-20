#import "BPCapturedImageResult.h"

const int CAPTURED_IMAGE_STATE_ADDING = 0;
const int CAPTURED_IMAGE_STATE_UPLOADING = 1;
const int CAPTURED_IMAGE_STATE_FINISHED = 2;

@implementation BPCapturedImageResult {
    
}
    
- (instancetype)initWithState:(int)state capturedImagesData:(BPCapturedImagesData *)imagesData imageIndex:(int)imageIndex {
    
    self = [super init];
    if (self) {
        self.state = state;
        self.imagesData = imagesData;
        self.imageIndex = imageIndex;
    }
    
    return self;
}

@end
