//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPCardViewProtocol.h"
#import "BPScanResult.h"
#import "BPCompanyContentView.h"

@class BPCompanyCardView;
@class BPMainProggressView;
@class BPSecondaryProgressView;
@class BPCheckRow;

@protocol BPProductCardViewDelegate <NSObject>

- (void)didTapReportProblem:(BPCompanyCardView *)productCardView;

@end

@interface BPCompanyCardView : UIView <BPCardViewProtocol>

@property(nonatomic, weak) id <BPProductCardViewDelegate> delegate;

- (void)setTitleHeight:(int)titleHeight;

- (void)setContentType:(CompanyContentType)contentType;

- (void)setTitleText:(NSString *)titleText;

- (void)setMainPercent:(CGFloat)mainPercent;

- (void)setCapitalPercent:(NSNumber *)capitalPercent notes:(NSString *)notes;

- (void)setWorkers:(NSNumber *)workers notes:(NSString *)notes;

- (void)setRnd:(NSNumber *)rnd notes:(NSString *)notes;

- (void)setRegistered:(NSNumber *)registered notes:(NSString *)notes;

- (void)setNotGlobal:(NSNumber *)notGlobal notes:(NSString *)notes;

- (void)setCardType:(CardType)type;

- (void)setReportButtonType:(ReportButtonType)type;

- (void)setReportButtonText:(NSString *)text;

- (void)setReportText:(NSString *)text;

- (void)setAltText:(NSString *)altText;

@end