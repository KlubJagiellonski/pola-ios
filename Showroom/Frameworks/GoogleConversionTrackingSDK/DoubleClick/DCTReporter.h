//
//  DCTReporter.h
//  DoubleClick for Publishers (DFP) Conversion Tracking.
//  Copyright 2011 Google Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ACTReporter.h"

/// Reports a DoubleClick for Publisher (DFP) conversion to Google.
@interface DCTConversionReporter : ACTReporter

/// String representation of conversion value. Example: @"3.99".
@property(nonatomic, copy) NSString *value;

/// String representation of currency code. Example: @"USD".
@property(nonatomic, copy) NSString *currencyCode;

/// Reports conversion information to Google.
+ (void)reportWithConversionID:(NSString *)conversionID
                         value:(NSString *)value
                  currencyCode:(NSString *)currencyCode
                  isRepeatable:(BOOL)isRepeatable;

/// Reports conversion information to Google.
+ (void)reportWithConversionID:(NSString *)conversionID
                         value:(NSString *)value
                  isRepeatable:(BOOL)isRepeatable;

/// Returns an initialized conversion DCTConversionReporter object for conversion ID reporting. Use
/// this method to separate conversion tracker initialization and reporting.
- (instancetype)initWithConversionID:(NSString *)conversionID
                               value:(NSString *)value
                        currencyCode:(NSString *)currencyCode
                        isRepeatable:(BOOL)isRepeatable;

/// Returns an initialized conversion DCTConversionReporter object for conversion ID reporting. Use
/// this method to separate conversion tracker initialization and reporting.
- (instancetype)initWithConversionID:(NSString *)conversionID
                               value:(NSString *)value
                        isRepeatable:(BOOL)isRepeatable;
@end

/// Reports a DoubleClick for Publisher (DFP) activity event for audience segmentation.
@interface DCTActivityReporter : ACTReporter

/// Report activity targeted at adUnitID with optional publisher identifier and recording
/// parameters.
+ (void)reportWithAdUnitID:(NSString *)adUnitID
       publisherProvidedID:(NSString *)publisherProvidedID
          customParameters:(NSDictionary *)customParameters;

/// Returns an initialized DCTActivityReporter object. Use this method to separate activity tracker
/// initialization and reporting. The ad unit is the only required parameter, other parameters may
/// be nil.
- (instancetype)initWithAdUnitID:(NSString *)adUnitID
             publisherProvidedID:(NSString *)publisherProvidedID
                customParameters:(NSDictionary *)customParameters;

@end
