//
//  PUPaymentRequest.h
//  PayU-iOS-SDK-Oneclick
//
//  Created by Przemyslaw Stasiak on 24.04.2014.
//  Copyright (c) 2014 PayU S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Parameters required for performing payment operation.
 */
@interface PUPaymentRequest : NSObject

/**
 *  Order identifier in the merchant system
 */
@property (nonatomic, copy) NSString *extOrderId;

/**
 *  Human readable payment description
 */
@property (nonatomic, copy) NSString *paymentDescription;

/**
 *  Payment amount in selected currency
 */
@property (nonatomic, copy) NSDecimalNumber *amount;

/**
 *  Payment currency
 *  @see http://en.wikipedia.org/wiki/ISO_4217
 */
@property (nonatomic, copy) NSString *currency;

/**
 *  URL that will be used to communicate payment status change
 */
@property (nonatomic, copy) NSURL *notifyURL;

@end

NS_ASSUME_NONNULL_END