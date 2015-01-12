#import <Foundation/Foundation.h>


@interface BPCompany : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSNumber *madeInPoland;
@property(nonatomic, copy) NSString *madeInPolandInfo;
@property(nonatomic, strong) NSNumber *capitalInPoland;
@property(nonatomic, copy) NSString *capitalInPolandInfo;
@property(nonatomic, strong) NSNumber *taxesInPoland;
@property(nonatomic, copy) NSString *taxesInPolandInfo;
@property(nonatomic, copy) NSString *krsUrl;
@property(nonatomic, copy) NSString *nip;
@property(nonatomic, copy) NSString *regon;

@end