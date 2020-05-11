#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BPDeviceHelper : NSObject

@property (class, nonatomic, readonly) NSString *deviceId;
@property (class, nonatomic, readonly) NSString *deviceInfo;
@property (class, nonatomic, readonly) NSString *deviceName;

@end

NS_ASSUME_NONNULL_END
