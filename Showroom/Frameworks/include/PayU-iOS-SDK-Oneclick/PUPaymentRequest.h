//
//  PUPaymentRequest.h
//  PayU-iOS-SDK-Oneclick
//
//  Created by Przemyslaw Stasiak on 24.04.2014.
//  Copyright (c) 2014 PayU S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  PUPaymentRequest class gathers parameters needed for performing payment.
 */
@interface PUPaymentRequest : NSObject

/**
 *  Order identifier in merchant system
 */
@property(nonatomic, copy) NSString *extOrderId;

/**
 *  Human readable payment description
 */
@property(nonatomic, copy) NSString *paymentDescription;

/**
 *  Payment amount
 */
@property(nonatomic, copy) NSDecimalNumber *amount;

/**
 *  Payment currency
 *  @see http://en.wikipedia.org/wiki/ISO_4217
 */
@property(nonatomic, copy) NSString *currency;

/**
 *  URL that will be used to communicate payment status change
 */
@property(nonatomic, copy) NSURL *notifyURL;

@end
