//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPReport : NSObject

@property(nonatomic, readonly) NSNumber *productId;
@property(nonatomic, readonly) NSString *desc;
@property(nonatomic, strong, readonly) NSArray *imagePathArray;
@property(nonatomic, strong) NSNumber *id;

- (instancetype)initWithProductId:(NSNumber *)productId description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray;

+ (instancetype)reportWithProductId:(NSNumber *)productId description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray;


@end