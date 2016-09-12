//
//  PUPaymentMethodDescription.h
//  PayU-iOS-SDK-Oneclick
//
//  Created by Przemyslaw Stasiak on 24.04.2014.
//  Copyright (c) 2014 PayU S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  PUPaymentMethodDescription class gathers parameters used in payment method representation.
 */
@interface PUPaymentMethodDescription : NSObject

/**
 *  Human readable payment method name
 */
@property(copy, nonatomic, readonly) NSString *displayName;

/**
 *  Human readable payment method additional description, like masked bank account number
 */
@property(copy, nonatomic, readonly) NSString *displayDetail;

/**
 *  URL for payment method logo image
 */
@property(copy, nonatomic, readonly) NSURL *imageUrl;

@end
