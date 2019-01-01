#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    CardTypeWhite,
    CardTypeGrey
} CardType;

typedef enum {
    ReportButtonTypeRed,
    ReportButtonTypeWhite
} ReportButtonType;

@interface BPScanResult : NSObject

@property(nonatomic, nullable) NSNumber *productId;
@property(nonatomic, nullable, copy) NSString *code;
@property(nonatomic, nullable, copy) NSString *name;
@property(nonatomic) CardType cardType;
@property(nonatomic, nullable) NSNumber *plScore;
@property(nonatomic, nullable, copy) NSString *altText;
@property(nonatomic, nullable) NSNumber *plCapital;
@property(nonatomic, nullable) NSNumber *plWorkers;
@property(nonatomic, nullable) NSNumber *plRnD;
@property(nonatomic, nullable) NSNumber *plRegistered;
@property(nonatomic, nullable) NSNumber *plNotGlobEnt;
@property(nonatomic, nullable, copy) NSString *descr;
@property(nonatomic, nullable, copy) NSString *reportText;
@property(nonatomic, nullable, copy) NSString *reportButtonText;
@property(nonatomic) ReportButtonType reportButtonType;
@property(nonatomic) BOOL askForPics;
@property(nonatomic, nullable, copy) NSString *askForPicsPreview;
@property(nonatomic, nullable, copy) NSString *askForPicsTitle;
@property(nonatomic, nullable, copy) NSString *askForPicsText;
@property(nonatomic, nullable, copy) NSString *askForPicsButtonStart;
@property(nonatomic, nullable, copy) NSString *askForPicsProduct;
@property(nonatomic, nullable, copy) NSNumber *maxPicSize;

@end

NS_ASSUME_NONNULL_END
