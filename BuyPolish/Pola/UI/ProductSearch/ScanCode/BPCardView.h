//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSInteger const CARD_TITLE_HEIGHT;

@interface BPCardView : UIView

@property(nonatomic, copy) NSString *productName;
@property(nonatomic, copy) NSString *barcode;
@property(nonatomic, strong) NSNumber *madeInPoland;
@property(nonatomic, copy) NSString *madeInPolandInfo;
@property(nonatomic, copy) NSString *companyName;
@property(nonatomic, strong) NSNumber *companyCapitalInPoland;
@property(nonatomic, copy) NSString *companyCapitalInPolandInfo;
@property(nonatomic, copy) NSString *companyNip;
@property(nonatomic) BOOL inProgress;

@end