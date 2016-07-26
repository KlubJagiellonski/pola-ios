//
//  PUPaymentService.h
//  PayU-iOS-SDK-Oneclick
//
//  Created by Przemyslaw Stasiak on 24.04.2014.
//  Copyright (c) 2014 PayU S.A. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PUPaymentRequest.h"
#import "PUPaymentMethodDescription.h"
#import "PUAuthorizationDataSource.h"
#import "PUPaymentRequestResult.h"

typedef NS_ENUM(NSInteger, PUPresentationStyle) {
    PUPresentationStyleInsideNavigationController = 1,
    PUPresentationStyleOutsideNavigationController
};

typedef void (^PUPaymentRequestCompletionHandler)(PUPaymentRequestResult *result);

@class PUPaymentService;
@protocol PUPaymentMethodViewControllerDelegate;

@protocol PUPaymentServiceDelegate <NSObject>

/**----------------------------------------------------------------------
 *  @name Presenting View Controller
 * ----------------------------------------------------------------------
 */

/**
 *  This method is invoked when Payment Service detect the need of presenting view controller to the user.
 *  When this call is received view controller **must** be presented on screen to enable user to add or select
 *  payment method.
 *  @warning Given controller **can't be pushed** onto UIViewController stack.
 *
 *  @param viewController Payment methods view controller, authorization view controller etc.
 */
- (void)paymentServiceDidRequestPresentingViewController:(UIViewController *)viewController;

/**
 *  This method notifies about changes to payment method that are visible in payment method widget. It is invoked on
 *  various events like: user selects payment method, widgets load previously selected payment method, user deletes 
 *  selected payment method ,etc.
 *
 *  Use this method to enable/disable payment button in merchant application.
 *
 *  @param paymentMethod  Selected payment method or nil, if no method is selected.
 */
@optional
- (void)paymentServiceDidSelectPaymentMethod:(PUPaymentMethodDescription *)paymentMethod;

@end

/**
 *  PUPaymentService class manages all aspects of adding and selecting payment methods and performing payment.
 */
@interface PUPaymentService : NSObject

/**
 *  Authorization data source
 */
@property(nonatomic, weak) id <PUAuthorizationDataSource> dataSource;

/**
 *  PUPaymentService delegate
 */
@property(nonatomic, weak) id <PUPaymentServiceDelegate> delegate;

/**----------------------------------------------------------------------
 *  @name Showing selected payment method
 * ----------------------------------------------------------------------
 */

/**
 *  Method for retrieving payment method widget. This widget is a UIView subclass that shows currently selected payment method.
 *  State and appearance of the widget is controlled internally the only responsibility of the client is to properly show widget on screen.
 *  When user interacts with the widget the Payment Service will inform its delegate that Payment Methods View Controller should be presented on screen.
 *
 *  @param frame Proposed frame for widget.
 *  @warning Widget will reposition its controls to reflect width changes but height is fixed to 50.
 */
- (UIView *)paymentMethodWidgetWithFrame:(CGRect)frame;

/**----------------------------------------------------------------------
 *  @name Submitting payment
 * ----------------------------------------------------------------------
 */

/**
 *  Method for submitting payment.
 *
 *  @param paymentRequest               PUPaymentRequest object containing transaction data.
 *  @param completionHandler            Code block that will be invoked when submitting is finished, or brake at some point with error.
 */
- (void)submitPaymentRequest:(PUPaymentRequest *)paymentRequest
           completionHandler:(PUPaymentRequestCompletionHandler)completionHandler;

/**----------------------------------------------------------------------
 *  @name Handling changing of user in merchant application
 * ----------------------------------------------------------------------
 */

/**
 *  Cleans up all data related to current user context.
 *  @note Sample usage scenarios: logging out user for which PUPaymentService instance is currently used,
 *  creating fresh instance of PUPaymentService for user different than last time. 
 * @warning If You are not using widget you must remember to refresh already presented selected payment method of logged out user!
 */
- (void)clearUserContext;

/**----------------------------------------------------------------------
 *  @name Handle response from external application
 * ----------------------------------------------------------------------
 */

/**
 *  This method enables forwarding of callback URL to SDK and is required to properly handle payment authorization with external applications.
 *  Should be called in UIApplicationDelegate in method - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
 *  @param callback URL which application was asked to open.
 */
- (BOOL)handleOpenURL:(NSURL *)callback;

@end
