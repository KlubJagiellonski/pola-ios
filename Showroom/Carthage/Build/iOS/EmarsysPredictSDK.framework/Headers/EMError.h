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

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const EMErrorDomain;

/*!
 * @typedef EMErrorCode
 * @brief These values are returned as the error code property of an NSError
 * object with the domain EMErrorDomain.
 * @constant EMErrorUnknown An unknown error has occurred.
 * @constant EMErrorMissingCDVCookie CDV cookie was not present in the HTTP
 * response.
 * @constant EMErrorBadHTTPStatus HTTP response returned other than code 200.
 * @constant EMErrorMissingJSONParameter HTTP response is missing an expected
 * JSON key.
 * @constant EMErrorMissingMerchantID Merchant ID was not set.
 * @constant EMErrorNonUniqueRecommendationLogic Non-unique recommendation logic
 * was used inside a transaction.
 */
typedef NS_ENUM(NSInteger, EMErrorCode) {
    EMErrorUnknown = -1,
    EMErrorMissingCDVCookie = -995,
    EMErrorBadHTTPStatus = -996,
    EMErrorMissingJSONParameter = -997,
    EMErrorMissingMerchantID = -998,
    EMErrorNonUniqueRecommendationLogic = -999
};

NS_ASSUME_NONNULL_END
