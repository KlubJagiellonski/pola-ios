#import <Foundation/Foundation.h>


@interface BPCompany : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSNumber *plWorkers;
@property(nonatomic, copy) NSString *plWorkersNotes;
@property(nonatomic, strong) NSNumber *plBrand;
@property(nonatomic, copy) NSString *plBrandNotes;
@property(nonatomic, strong) NSNumber *plTaxes;
@property(nonatomic, copy) NSString *plTaxesNotes;
@property(nonatomic, strong) NSNumber *plCapital;
@property(nonatomic, copy) NSString *plCapitalNotes;
@property(nonatomic, strong) NSNumber *plRnD;
@property(nonatomic, copy) NSString *plRnDNotes;

@end