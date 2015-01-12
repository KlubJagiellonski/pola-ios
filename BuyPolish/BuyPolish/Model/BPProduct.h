#import <Foundation/Foundation.h>

@class BPCompany;


@interface BPProduct : NSObject

@property(nonatomic, copy) NSString *barcode;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSNumber *madeInPoland;
@property(nonatomic, copy) NSString *madeInPolandInfo;
@property(nonatomic, strong) BPCompany *company;

@end