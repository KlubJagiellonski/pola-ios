#import <Foundation/Foundation.h>


@interface BPReport : NSObject

@property(nonatomic, readonly) NSNumber *productId;
@property(copy, nonatomic, readonly) NSString *desc;
@property(copy, nonatomic, readonly) NSArray *imagePathArray;
@property(nonatomic, strong) NSNumber *reportId;

- (instancetype)initWithProductId:(NSNumber *)productId description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray;

+ (instancetype)reportWithProductId:(NSNumber *)productId description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray;


@end