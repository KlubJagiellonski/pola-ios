#import <Foundation/Foundation.h>
#import "BPScanResult.h"

typedef enum {
    CompanyContentTypeDefault,
    CompanyContentTypeLoading,
    CompanyContentTypeAlt,
} CompanyContentType;

@interface BPCompanyContentView : UIScrollView

@property(nonatomic) int padding;

@property(nonatomic) CompanyContentType contentType;

- (void)setCapitalPercent:(NSNumber *)capitalPercent;

- (void)setWorkers:(NSNumber *)workers;

- (void)setRnd:(NSNumber *)rnd;

- (void)setRegistered:(NSNumber *)registered;

- (void)setNotGlobal:(NSNumber *)notGlobal;

- (void)setAltText:(NSString *)simpleText;

- (void)setDescr:(NSString *)description;

- (void)setCardType:(CardType)type;
@end