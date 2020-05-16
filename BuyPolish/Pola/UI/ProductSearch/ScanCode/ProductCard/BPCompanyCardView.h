#import "BPCompanyContentView.h"
#import "BPScanResult.h"
#import "BPStackView.h"
#import <Foundation/Foundation.h>

@class BPCompanyCardView;
@class BPMainProggressView;
@class BPSecondaryProgressView;
@class BPCheckRow;

@protocol BPCompanyCardViewDelegate <NSObject>

- (void)productCardViewDidTapReportProblem:(BPCompanyCardView *)productCardView;
- (void)productCardViewDidTapTeach:(BPCompanyCardView *)productCardView;
- (void)productCardViewDidTapFriendButton:(BPCompanyCardView *)productCardView;

@end

@interface BPCompanyCardView : UIView <BPStackViewCardProtocol>

@property (nonatomic) CGFloat titleHeight;
@property (nonatomic, readonly) UILabel *titleLabel;

@property (weak, nonatomic) id<BPCompanyCardViewDelegate> delegate;

- (void)setContentType:(CompanyContentType)contentType;

- (void)setTitleText:(NSString *)titleText;

- (void)setMainPercent:(CGFloat)mainPercent;

- (void)setCapitalPercent:(NSNumber *)capitalPercent;

- (void)setWorkers:(NSNumber *)workers;

- (void)setRnd:(NSNumber *)rnd;

- (void)setRegistered:(NSNumber *)registered;

- (void)setNotGlobal:(NSNumber *)notGlobal;

- (void)setCardType:(CardType)type;

- (void)setTeachButtonText:(NSString *)teachButtonText;

- (void)setReportButtonType:(ReportButtonType)type;

- (void)setReportButtonText:(NSString *)text;

- (void)setReportText:(NSString *)text;

- (void)setDescr:(NSString *)description;

- (void)setAltText:(NSString *)altText;

- (void)setMarkAsFriend:(BOOL)isFriend;

@end
