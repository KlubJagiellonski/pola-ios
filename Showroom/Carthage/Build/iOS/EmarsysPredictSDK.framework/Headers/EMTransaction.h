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

#import <EmarsysPredictSDK/EMCartItem.h>
#import <EmarsysPredictSDK/EMRecommendationRequest.h>

#pragma mark - EmarsysPredictSDK Transaction -

NS_ASSUME_NONNULL_BEGIN

/*!
 * @brief The transaction.
 * @warning Please send transaction instances only once.
 */
@interface EMTransaction : NSObject

/*!
 * @brief Initializes a newly allocated transaction instance.
 */
- (instancetype)init;
/*!
 * @brief Initializes a newly allocated transaction instance, if the user comes
 * from selected(clicked) a recommended item
 * @param item The previously selected item object
 */
- (instancetype)initWithSelectedItemView:(nullable EMRecommendationItem *)item;
/*!
 * @brief Creates and returns an transaction instance.
 * @param item Result item from the last recommendation result.
 */
+ (instancetype)transactionWithItem:(nullable EMRecommendationItem *)item;

/*!
 * @brief Set availability zone.
 * @discussion See JavaScript API reference for more explonation.
 * @param availabilityZone ID of the availability zone.
 */
- (void)setAvailabilityZone:(NSString *)availabilityZone;
/*!
 * @brief Report a purchase event.
 * @discussion This command should be called on the order confirmation page to
 * report successful purchases. Also make sure all purchased items are passed to
 * the command.
 * @param orderID ID of the purchase.
 * @param items Array of purchased objects.
 */
- (void)setPurchase:(NSString *)orderID ofItems:(NSArray<EMCartItem *> *)items;
/*!
 * @brief Set search terms entered by visitor.
 * @discussion This call should be placed in the search results page.
 * @param searchTerm Search term entered by user.
 */
- (void)setSearchTerm:(NSString *)searchTerm;
/*!
 * @brief Report a product browsed by visitor.
 * @discussion This command should be placed in all product pages – i.e. pages
 * showing a single item in detail. Recommender features RELATED and ALSO_BOUGHT
 * depend on this call.
 * @param itemID ID of the viewed item (consistent with the item column
 * specified in the catalog).
 */
- (void)setView:(NSString *)itemID;
/*!
 * @brief Report the list of items in the visitor's shopping cart.
 * @discussion This command should be called on every page. Make sure all cart
 * items are passed to the command. If the visitor's cart is empty, send the
 * empty array.
 * @param items Array of cart objects.
 */
- (void)setCart:(NSArray<EMCartItem *> *)items;
/*!
 * @brief Report the category currently browsed by visitor.
 * @discussion Should be called on all category pages. Pass a valid category
 * path.
 * @param category Category path.
 */
- (void)setCategory:(NSString *)category;
/*!
 * @brief Report the keyword used by visitors to refine their searches.
 * @discussion Brands, locations, price ranges are good examples of such
 * keywords. If your site offers such features, you can pass keywords to the
 * recommender system with this command.
 * @param keyword Keyword selected by user.
 */
- (void)setKeyword:(NSString *)keyword;
/*!
 * @brief Add an arbitrary tag to the current event. The tag is collected and
 * can be accessed later from other Emarsys products.
 * @discussion This command can be issued on any page.
 * @param tag Tag selected by user.
 */
- (void)setTag:(NSString *)tag;
/*!
 * @brief Request recommendations.
 * @discussion See usage examples and the list of available recommendation
 * strategies.
 * @param request Recommendation request instance.
 */
- (void)recommend:(EMRecommendationRequest *)request;

@end

NS_ASSUME_NONNULL_END
