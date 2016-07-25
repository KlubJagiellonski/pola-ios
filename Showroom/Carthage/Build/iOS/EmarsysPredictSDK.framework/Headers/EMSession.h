/*
 * Copyright 2016 Scarab Research Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import <EmarsysPredictSDK/EMTransaction.h>
#import <UIKit/UIKit.h>

#pragma mark - EmarsysPredictSDK Session -

NS_ASSUME_NONNULL_BEGIN

/*!
 * @typedef EMLogLevel
 * @brief A list of log levels.
 * @constant EMLogLevelDebug Print messages with debug or greater severity.
 * @constant EMLogLevelInfo Print messages with info or greater severity.
 * @constant EMLogLevelWarning Print messages with warning or greater severity.
 * @constant EMLogLevelError Print messages only with error severity.
 * @constant EMLogLevelNone Does not print any messages.
 */
typedef NS_ENUM(uint8_t, EMLogLevel) {
    EMLogLevelDebug,
    EMLogLevelInfo,
    EMLogLevelWarning,
    EMLogLevelError,
    EMLogLevelNone = 0xFF
};

/*!
 * @brief The global EmarsysPredictSDK session object.
 */
@interface EMSession : NSObject

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;

/*!
 * @brief Returns the shared session.
 */
+ (EMSession *)sharedSession;

/*!
 * @brief Send transaction to the recommender server.
 * @param transaction An EMTransaction instance to be send.
 * @warning Please send the transaction only once.
 * @param errorHandler Will be called if an error occurs.
 */
- (void)sendTransaction:(EMTransaction *)transaction
           errorHandler:(void (^)(NSError *error))errorHandler;

/*!
 * @brief Merchant ID.
 */
@property(readwrite, nullable) NSString *merchantID;
/*!
 * @brief Customer email address.
 */
@property(readwrite, nullable) NSString *customerEmail;
/*!
 * @brief Customer ID.
 */
@property(readwrite, nullable) NSString *customerID;
/*!
 * @brief Advertising ID.
 */
@property(readonly, nullable, nonatomic) NSString *advertisingID;
/*!
 * @brief Log level.
 */
@property(readwrite) EMLogLevel logLevel;
/*!
 * @brief Set connection to secure or insecure.
 */
@property(readwrite) BOOL secure;

@end

NS_ASSUME_NONNULL_END
