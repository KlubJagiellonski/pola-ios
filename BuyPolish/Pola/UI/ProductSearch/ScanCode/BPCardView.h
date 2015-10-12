//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const CARD_TITLE_HEIGHT;

@interface BPCardView : UIView

@property(nonatomic) BOOL inProgress;

- (void)setLeftHeaderText:(NSString *)leftHeaderText;

- (void)setRightHeaderText:(NSString *)rightHeaderText;

@end