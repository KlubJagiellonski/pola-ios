#import <Foundation/Foundation.h>
#import "BPScanResult.h"
#import "BPCompanyContentView.h"
#import "BPStackView.h"


@class BPCompanyCardView;
@class BPMainProggressView;
@class BPSecondaryProgressView;
@class BPCheckRow;

@protocol BPCompanyCardViewDelegate <NSObject>

- (void)didTapReportProblem:(BPCompanyCardView *)productCardView;

@end

@interface BPCompanyCardView : UIView <BPStackViewCardProtocol>

@property(nonatomic) CGFloat titleHeight;

@property(nonatomic, weak) id <BPCompanyCardViewDelegate> delegate;

- (void)setContentType:(CompanyContentType)contentType;

- (void)setTitleText:(NSString *)titleText;

- (void)setMainPercent:(CGFloat)mainPercent;

- (void)setCapitalPercent:(NSNumber *)capitalPercent;

- (void)setWorkers:(NSNumber *)workers;

- (void)setRnd:(NSNumber *)rnd;

- (void)setRegistered:(NSNumber *)registered;

- (void)setNotGlobal:(NSNumber *)notGlobal;

- (void)setCardType:(CardType)type;

- (void)setReportButtonType:(ReportButtonType)type;

- (void)setReportButtonText:(NSString *)text;

- (void)setReportText:(NSString *)text;

- (void)setDescr:(NSString *)description;

- (void)setAltText:(NSString *)altText;

@end