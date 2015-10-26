//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPAboutRow.h"


@interface BPWebAboutRow : BPAboutRow

@property(nonatomic, copy) NSString *url;

@property(nonatomic, copy) NSString *analyticsName;

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url analyticsName:(NSString *)analyticsName;

+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url analyticsName:(NSString *)analyticsName;

@end