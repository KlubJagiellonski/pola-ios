#import <Foundation/Foundation.h>

@class BPCompany;


@interface BPProductResult : NSObject

@property(nonatomic) NSNumber *verified;
@property(nonatomic, strong) NSNumber *plScore;
@property(nonatomic, copy) NSString *report;
@property(nonatomic, strong) BPCompany *company;
@property(nonatomic, copy) NSString *barcode;

- (instancetype)initWithBarcode:(NSString *)barcode;
@end