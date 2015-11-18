//
// Created by Paweł Janeczek on 26/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPScanResult;


@interface BPAnalyticsHelper : NSObject

+ (void)barcodeScanned:(NSString *)barcode;
+ (void)receivedProductResult:(BPScanResult *)productResult;
+ (void)opensCard:(BPScanResult *)productResult;
+ (void)reportShown:(NSString *)barcode;
+ (void)reportSent:(NSString *)barcode success:(BOOL)success;
+ (void)aboutOpened:(NSString *)windowName;

@end