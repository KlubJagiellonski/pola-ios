//
//  PUPaymentRequestResult.h
//  PayU-iOS-SDK-Oneclick
//
//  Created by Maciej Jastrzebski on 24.11.2015.
//  Copyright (c) 2014 PayU S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PUPayment2ndStepAuth;

typedef NS_ENUM(NSInteger, PUPaymentRequestStatus) {
    PUPaymentRequestStatusSuccess = 1,
    PUPaymentRequestStatusRetry,
    PUPaymentRequestStatusFailure
};

@interface PUPaymentRequestResult : NSObject

/**
 * Status of the payment request.
 */
@property (nonatomic, readonly) PUPaymentRequestStatus status;

/**
 * Order identifier in PayU system.
 *
 * @note Present only when payment request succeeded.
 */
@property (nonatomic, strong, readonly) NSString *orderId;

/**
 * Order identifier in merchant system.
 *
 * @note Present only when payment request succeeded.
 */
@property (nonatomic, strong, readonly) NSString *extOrderId;

/**
 * Error object.
 *
 * @note Present only when payment request failed.
 */
@property (nonatomic, strong, readonly) NSError *error;

- (instancetype)initWithStatus:(PUPaymentRequestStatus)status orderId:(NSString *)orderId extOrderId:(NSString *)extOrderId error:(NSError *)error;

+ (instancetype)successResultWithOrderId:(NSString *)orderId extOrderId:(NSString *)extOrderId;

+ (instancetype)retryResultWithError:(NSError *)error;

+ (instancetype)failureResultWithError:(NSError *)error;

@end