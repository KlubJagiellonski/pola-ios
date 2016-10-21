//
//  PUAuthorizationDataSource.h
//  PayU-iOS-SDK-Oneclick
//
//  Created by Daniel Deneka on 22.05.2014.
//  Copyright (c) 2014 PayU S.A. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  PUAuthorizationDataSource protocol manages refreshing of merchant access token.
 */
@protocol PUAuthorizationDataSource <NSObject>

/**----------------------------------------------------------------------
 *  @name Refreshing merchant access token
 * ----------------------------------------------------------------------
 */

@required
/** 
 *  Method for refreshing merchant access token.
 *  If refreshing is successful new merchant access token **must** be passed to completionHandler code block.
 *
 *  @param completionHandler Block of code that **must** be invoked after success or failure when trying to refresh the token.
 *  @warning method may be called several times
 */
- (void)refreshTokenWithCompletionHandler:(void (^)(NSString *accessToken, NSError *error))completionHandler;

/**----------------------------------------------------------------------
 *  @name Application callback scheme provider
 * ----------------------------------------------------------------------
 */

/**
 * Method for providing SDK with registered application callback scheme. This information is needed in payment authorization with use of i.e. bank applications installed on device.
 *
 *  Method gets called when it is possible to authorize payment using bank application. Returned scheme must be registered in application info plist and be valid URL scheme.
 */
/*  Info plist entry example:
 	<key>CFBundleURLTypes</key>
	<array>
		<dict>
			<key>CFBundleURLName</key>
			<string>com.example.yourappname</string>
			<key>CFBundleURLSchemes</key>
			<array>
				<string>your-callback-scheme</string>
			</array>
		</dict>
	</array>
 */
- (NSString *)applicationCallbackScheme;

@end
