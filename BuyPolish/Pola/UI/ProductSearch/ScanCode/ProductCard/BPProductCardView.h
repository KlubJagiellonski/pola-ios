//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPCardViewProtocol.h"

@class BPProductCardView;
@class BPMainProggressView;
@class BPSecondaryProgressView;
@class BPCheckRow;

@protocol BPProductCardViewDelegate <NSObject>

- (void)didTapReportProblem:(BPProductCardView *)productCardView;

@end

@interface BPProductCardView : UIView <BPCardViewProtocol>

@property(nonatomic) BOOL inProgress;

@property(nonatomic) int titleHeight;

@property(nonatomic, weak) id <BPProductCardViewDelegate> delegate;

- (void)setTitleText:(NSString *)titleText;

- (void)setMainPercent:(CGFloat)mainPercent;

- (void)setCapitalPercent:(NSNumber *)capitalPercent;

- (void)setProducesInPoland:(BOOL)producesInPoland;

- (void)setRnd:(BOOL)rnd;

- (void)setRegisteredInPoland:(BOOL)registeredInPoland;

- (void)setNotGlobal:(BOOL)notGlobal;

- (void)setNeedsData:(BOOL)needsData;
@end