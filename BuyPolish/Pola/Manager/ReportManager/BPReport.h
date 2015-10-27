//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPReport : NSObject

@property(nonatomic, readonly) NSString *key;
@property(nonatomic, readonly) NSString *desc;
@property(nonatomic, strong, readonly) NSArray *imagePathArray;
@property(nonatomic, strong) NSNumber *id;

- (instancetype)initWithKey:(NSString *)key description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray;

+ (instancetype)reportWithKey:(NSString *)key description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray;


@end