//
// Created by Paweł on 19/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BPReport : NSObject

@property(nonatomic, readonly) NSString *barcode;
@property(nonatomic, readonly) NSString *desc;
@property(nonatomic, strong, readonly) NSArray *imagePathArray;
@property(nonatomic, strong) NSNumber *id;

- (instancetype)initWithBarcode:(NSString *)barcode description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray;

+ (instancetype)reportWithBarcode:(NSString *)barcode description:(NSString *)desc imagePathArray:(NSArray *)imagePathArray;


@end