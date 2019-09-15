#import "BPScanResult.h"
#import <Foundation/Foundation.h>

typedef enum {
    CompanyContentTypeDefault,
    CompanyContentTypeLoading,
    CompanyContentTypeAlt,
} CompanyContentType;

@interface BPCompanyContentView : UIScrollView

@property (nonatomic) CGFloat padding;

@property (nonatomic) CompanyContentType contentType;

- (void)setCapitalPercent:(NSNumber *)capitalPercent;

- (void)setWorkers:(NSNumber *)workers;

- (void)setRnd:(NSNumber *)rnd;

- (void)setRegistered:(NSNumber *)registered;

- (void)setNotGlobal:(NSNumber *)notGlobal;

- (void)setAltText:(NSString *)simpleText;

- (void)setDescr:(NSString *)description;

- (void)setCardType:(CardType)type;

- (void)setMarkAsFriend:(BOOL)isFriend;

- (void)addTargetOnFriendButton:(id)target action:(SEL)action;

@end
