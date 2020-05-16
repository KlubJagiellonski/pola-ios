#import <Foundation/Foundation.h>

@interface BPCapturedImagesData : NSObject

@property (nonatomic) NSNumber *productID;
@property (nonatomic) NSNumber *filesCount;
@property (nonatomic, copy) NSString *fileExtension;
@property (nonatomic, copy) NSString *mimeType;
@property (nonatomic) NSNumber *originalWidth;
@property (nonatomic) NSNumber *originalHeight;
@property (nonatomic) NSNumber *width;
@property (nonatomic) NSNumber *height;
@property (nonatomic, copy) NSString *deviceName;

- (instancetype)initWithProductID:(NSNumber *)productID
                       filesCount:(NSNumber *)filesCount
                    fileExtension:(NSString *)fileExtension
                         mimeType:(NSString *)mimeType
                    originalWidth:(NSNumber *)originalWidth
                   originalHeight:(NSNumber *)originalHeight
                            width:(NSNumber *)width
                           height:(NSNumber *)height
                       deviceName:(NSString *)deviceName;
@end
