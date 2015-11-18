#import <Foundation/Foundation.h>

typedef enum {
    CardTypeWhite,
    CardTypeGrey
} CardType;

typedef enum {
    ReportButtonTypeRed,
    ReportButtonTypeWhite
} ReportButtonType;

@interface BPScanResult : NSObject

@property(nonatomic) NSNumber *id;
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *name;
@property(nonatomic) CardType cardType;
@property(nonatomic, strong) NSNumber *plScore;
@property(nonatomic, copy) NSString *altText;
@property(nonatomic, strong) NSNumber *plCapital;
@property(nonatomic, copy) NSString *plCapitalNotes;
@property(nonatomic, strong) NSNumber *plWorkers;
@property(nonatomic, copy) NSString *plWorkersNotes;
@property(nonatomic, strong) NSNumber *plRnD;
@property(nonatomic, copy) NSString *plRnDNotes;
@property(nonatomic, strong) NSNumber *plRegistered;
@property(nonatomic, copy) NSString *plRegisteredNotes;
@property(nonatomic, strong) NSNumber *plNotGlobEnt;
@property(nonatomic, copy) NSString *plNotGlobEntNotes;
@property(nonatomic, copy) NSString *reportText;
@property(nonatomic, copy) NSString *reportButtonText;
@property(nonatomic) ReportButtonType reportButtonType;

- (instancetype)initWithCode:(NSString *)code;
@end