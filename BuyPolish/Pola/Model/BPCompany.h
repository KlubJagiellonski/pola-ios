#import <Foundation/Foundation.h>


@interface BPCompany : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSNumber *plWorkers;
@property(nonatomic, copy) NSString *plWorkersNotes;
@property(nonatomic, strong) NSNumber *plBrand;
@property(nonatomic, copy) NSString *plBrandNotes;
@property(nonatomic, strong) NSNumber *plTaxes;
@property(nonatomic, copy) NSString *plTaxesNotes;

@property(nonatomic, strong) NSNumber *capitalInPoland;
@property(nonatomic, copy) NSString *capitalInPolandInfo;
@property(nonatomic, copy) NSString *nip;
@property(nonatomic, copy) NSString *address;

@end