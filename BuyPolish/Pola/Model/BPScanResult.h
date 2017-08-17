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

@property(nonatomic) NSNumber *productId;
@property(nonatomic, copy) NSString *code;
@property(nonatomic, copy) NSString *name;
@property(nonatomic) CardType cardType;
@property(nonatomic) NSNumber *plScore;
@property(nonatomic, copy) NSString *altText;
@property(nonatomic) NSNumber *plCapital;
@property(nonatomic) NSNumber *plWorkers;
@property(nonatomic) NSNumber *plRnD;
@property(nonatomic) NSNumber *plRegistered;
@property(nonatomic) NSNumber *plNotGlobEnt;
@property(copy, nonatomic, copy) NSString *descr;
@property(copy, nonatomic) NSString *reportText;
@property(copy, nonatomic) NSString *reportButtonText;
@property(nonatomic) ReportButtonType reportButtonType;
@property(nonatomic) BOOL askForPics;
@property(nonatomic, copy) NSString *askForPicsPreview;
@property(nonatomic, copy) NSString *askForPicsTitle;
@property(nonatomic, copy) NSString *askForPicsText;
@property(nonatomic, copy) NSString *askForPicsButtonStart;
@property(nonatomic, copy) NSString *askForPicsProduct;
@property(nonatomic, copy) NSNumber *maxPicSize;

- (instancetype)initWithCode:(NSString *)code;
@end
