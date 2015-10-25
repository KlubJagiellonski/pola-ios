//
// Created by Paweł on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPInfoRow.h"


@interface BPWebInfoRow : BPInfoRow

@property(nonatomic, copy) NSString *url;

- (instancetype)initWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url;

+ (instancetype)rowWithTitle:(NSString *)title action:(SEL)action url:(NSString *)url;

@end