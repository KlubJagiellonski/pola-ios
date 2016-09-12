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

#import <EmarsysPredictSDK/EMRecommendationResult.h>

#pragma mark - Recommendation Request -

NS_ASSUME_NONNULL_BEGIN

/*!
 * @brief The recommendation request.
 * @warning EMRecommendationRequests are not reusable.
 */
@interface EMRecommendationRequest : NSObject

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;
/*!
 * @brief Initializes a newly allocated request instance.
 * @param logic The recommendation strategy to be used. Eg. recommend similar
 * products (RELATED), or show personal recommendations (PERSONAL), etc.
 */
- (instancetype)initWithLogic:(NSString *)logic;
/*!
 * @brief Creates and returns a request instance.
 * @param logic The recommendation strategy to be used. Eg. recommend similar
 * products (RELATED), or show personal recommendations (PERSONAL), etc.
 */
+ (instancetype)requestWithLogic:(NSString *)logic;

/*!
 * @brief Set exclude criteria.
 * @discussion Exclude items where catalog field value is exactly the given
 * value.
 * @param catalogField Catalog field name.
 * @param value Value to compare against.
 */
- (void)excludeItemsWhere:(NSString *)catalogField is:(NSString *)value;
/*!
 * @brief Set exclude criteria.
 * @discussion Exclude items where catalog field value is contained in the given
 * array of values.
 * @param catalogField Catalog field name.
 * @param array Values to compare against.
 */
- (void)excludeItemsWhere:(NSString *)catalogField
                     isIn:(NSArray<NSString *> *)array;
/*!
 * @brief Set exclude criteria.
 * @discussion Exclude items where catalog field (a | separated list) contains
 * the given value.
 * @param catalogField Catalog field name.
 * @param value Value to compare against.
 */
- (void)excludeItemsWhere:(NSString *)catalogField has:(NSString *)value;
/*!
 * @brief Set exclude criteria.
 * @discussion Exclude items where catalog field (a | separated list) overlaps
 * with the given array of values.
 * @param catalogField Catalog field name.
 * @param array Values to compare against.
 */
- (void)excludeItemsWhere:(NSString *)catalogField
                 overlaps:(NSArray<NSString *> *)array;
/*!
 * @brief Set include criteria.
 * @discussion Include items where catalog field value is exactly the given
 * value.
 * @param catalogField Catalog field name.
 * @param value Value to compare against.
 */
- (void)includeItemsWhere:(NSString *)catalogField is:(NSString *)value;
/*!
 * @brief Set include criteria.
 * @discussion Include items where catalog field value is contained in the given
 * array of values.
 * @param catalogField Catalog field name.
 * @param array Values to compare against.
 */
- (void)includeItemsWhere:(NSString *)catalogField
                     isIn:(NSArray<NSString *> *)array;
/*!
 * @brief Set include criteria.
 * @discussion Include items where catalog field (a | separated list) contains
 * the given value.
 * @param catalogField Catalog field name.
 * @param value Value to compare against.
 */
- (void)includeItemsWhere:(NSString *)catalogField has:(NSString *)value;
/*!
 * @brief Set include criteria.
 * @discussion Include items where catalog field (a | separated list) overlaps
 * with the given array of values.
 * @param catalogField Catalog field name.
 * @param array Values to compare against.
 */
- (void)includeItemsWhere:(NSString *)catalogField
                 overlaps:(NSArray<NSString *> *)array;

/*!
 * @brief Recommendation logic.
 * @warning Must be unique per-transaction.
 */
@property(readonly) NSString *logic;
/*!
 * @brief Number of items to recommend.
 * discussion Default: 5.
 */
@property(readwrite) int limit;
/*!
 * @brief The item IDs of the original recommendations.
 * discussion Only used when an A/B test is in progress to compare the
 * performance of the EmarsysPredictSDK recommendations vs. the original (baseline)
 * recommendations.
 */
@property(readwrite, copy, nullable) NSArray<NSString *> *baseline;
/*!
 * @brief Callback for the completion handling.
 */
@property(readwrite, copy) void (^completionHandler)
    (EMRecommendationResult *completionHandler);

@end

NS_ASSUME_NONNULL_END
