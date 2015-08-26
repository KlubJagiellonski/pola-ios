#import <Foundation/Foundation.h>


@interface BPCompany : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, strong) NSNumber *capitalInPoland;
@property(nonatomic, copy) NSString *capitalInPolandInfo;
@property(nonatomic, copy) NSString *nip;
@property(nonatomic, copy) NSString *address;

@end