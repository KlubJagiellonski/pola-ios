//
//  PUErrorCode.h
//  PayU-iOS-SDK-Oneclick
//
//  Created by Daniel Deneka on 09.09.2014.
//  Copyright (c) 2014 PayU S.A. All rights reserved.
//

extern NSString * const PUBusinessErrorDomain;

typedef NS_ENUM(NSInteger, PUErrorCode) {
    PUErrorCodeUnexpected = 0,
    PUErrorCodeInvalidPaymentRequest,
    PUErrorCodeTooSmallAmount,
    PUErrorCodeEmptyPaymentId,
    PUErrorCodeEmptyDescription,
    PUErrorCodeUnsupportedCurrency,
    PUErrorCodeInvalidToken,
    PUErrorCodePaymentAdditionalAuthFailure,
    PUErrorCodeEmptyPaymentMethod,
    PUErrorCodePaymentCancelledByUser,
    PUErrorCodeExteralPaymentCancelledByUser,
    PUErrorCodeExteralPaymentInterruptedByUser,
    PUErrorCodeExteralPaymentError,
    PUErrorCodeUnimplemented,
    PUErrorCodeUnsupportedAuthorization,
};
