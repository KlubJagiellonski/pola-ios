//
// Created by Paweł on 19/11/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPScanResult.h"

typedef enum {
    CompanyContentTypeDefault,
    CompanyContentTypeLoading,
    CompanyContentTypeAlt,
} CompanyContentType;

@interface BPCompanyContentView : UIScrollView

@property(nonatomic) int titleHeight;

@property(nonatomic) int padding;

@property(nonatomic) CompanyContentType contentType;

- (void)setTitleText:(NSString *)titleText;

- (void)setMainPercent:(CGFloat)mainPercent;

- (void)setCapitalPercent:(NSNumber *)capitalPercent notes:(NSString *)notes;

- (void)setWorkers:(NSNumber *)workers notes:(NSString *)notes;

- (void)setRnd:(NSNumber *)rnd notes:(NSString *)notes;

- (void)setRegistered:(NSNumber *)registered notes:(NSString *)notes;

- (void)setNotGlobal:(NSNumber *)notGlobal notes:(NSString *)notes;

- (void)setAltText:(NSString *)simpleText;

- (void)setCardType:(CardType)type;
@end