#import "BPCapturedImagesData.h"

@implementation BPCapturedImagesData

- (instancetype)initWithProductID:(NSNumber *)productID
                       filesCount:(NSNumber *)filesCount
                    fileExtension:(NSString *)fileExtension
                         mimeType:(NSString *)mimeType
                    originalWidth:(NSNumber *)originalWidth
                   originalHeight:(NSNumber *)originalHeight
                            width:(NSNumber *)width
                           height:(NSNumber *)height
                       deviceName:(NSString *)deviceName {
    self = [super init];
    if (self) {
        _productID = productID;
        _filesCount = filesCount;
        _fileExtension = fileExtension;
        _mimeType = mimeType;
        _originalWidth = originalWidth;
        _originalHeight = originalHeight;
        _width = width;
        _height = height;
        _deviceName = deviceName;
    }
    return self;
}
@end
