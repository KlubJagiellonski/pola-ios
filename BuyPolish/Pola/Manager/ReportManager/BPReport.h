#import <Foundation/Foundation.h>


@interface BPReport : NSObject

@property(nonatomic, readonly) NSNumber *productId;
@property(nonatomic, readonly, copy) NSString *desc;
@property(nonatomic, strong, readonly) NSArray *imagePathArray;
@property(nonatomic, strong) NSNumber *id;

- (instancetype)initWithProductId:(NSNumber *)productId description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray;

+ (instancetype)reportWithProductId:(NSNumber *)productId description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray;


@end