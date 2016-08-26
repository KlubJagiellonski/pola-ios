//
//  OMGSDK.h
//  OMGSDK
//
//  Created by Deepak Gupta on 20/06/14.
//  Copyright (c) 2014 Omg Networks. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum tagActionType {
    Decline,
    End,
    Pending,
    Referral,
    Reject,
    Start,
    Basket,
    Content,
    Details,
    Existing,
    Home,
    Landing,
    Landing2,
    Payment,
    Preferences,
    Product,
    Quote,
    QuoteDetails,
    Sale,
}ActionType;

@interface OMGSDK : NSObject
    
+(OMGSDK *)sharedManager;

// set Global variable's
-(void)setApiKey:(NSString *)apiKey;
-(void)setMerchantID:(NSInteger)mid;

//optional method
-(void)setLatitude:(double)latitude;
-(void)setLongitude:(double)longitude;
-(void)trackInstallWhereAppID:(NSString *)appID ProductID:(NSInteger)pID deepLink:(BOOL)enabled Ex1:(NSString *)e1 Ex2:(NSString *)e2 Ex3:(NSString *)e3 Ex4:(NSString *)e4 Ex5:(NSString *)e5;
-(void)trackSalesWhereAppID:(NSString *)appID ProductID:(NSInteger)pID status:(NSString *)st currency:(NSString *)c Ex1:(NSString *)e1 Ex2:(NSString *)e2 Ex3:(NSString *)e3 Ex4:(NSString *)e4 Ex5:(NSString *)e5;
-(void)trackEventWhereAppID:(NSString *)appID ProductID:(NSInteger)pID status:(NSString *)st actionType:(ActionType)action Ex1:(NSString *)e1 Ex2:(NSString *)e2 Ex3:(NSString *)e3 Ex4:(NSString *)e4 Ex5:(NSString *)e5;

@end


