//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPCardViewProtocol.h"

@class BPProductCardView;

@protocol BPProductCardViewDelegate <NSObject>

- (void)didTapReportProblem:(BPProductCardView *)productCardView;

@end

@interface BPProductCardView : UIView <BPCardViewProtocol>

@property(nonatomic) BOOL inProgress;

@property(nonatomic) int titleHeight;

@property(nonatomic, weak) id <BPProductCardViewDelegate> delegate;

- (void)setLeftHeaderText:(NSString *)leftHeaderText;

- (void)setRightHeaderText:(NSString *)rightHeaderText;

@end