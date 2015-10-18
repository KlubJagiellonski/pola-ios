#import <Foundation/Foundation.h>


@interface BPCompany : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSNumber *plWorkers;
@property(nonatomic, copy) NSString *plWorkersNotes;
@property(nonatomic, strong) NSNumber *plRegistered;
@property(nonatomic, copy) NSString *plRegisteredNotes;
@property(nonatomic, strong) NSNumber *plNotGlobEnt;
@property(nonatomic, copy) NSString *plNotGlobEntNotes;
@property(nonatomic, strong) NSNumber *plCapital;
@property(nonatomic, copy) NSString *plCapitalNotes;
@property(nonatomic, strong) NSNumber *plRnD;
@property(nonatomic, copy) NSString *plRnDNotes;

@end