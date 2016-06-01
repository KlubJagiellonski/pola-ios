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

#pragma mark - Cart Item -

NS_ASSUME_NONNULL_BEGIN

/*!
 * @brief The cart item.
 */
@interface EMCartItem : NSObject

- (nullable instancetype)init UNAVAILABLE_ATTRIBUTE;

/*!
 * @brief Initializes a newly allocated item instance.
 */
- (instancetype)initWithItemID:(NSString *)itemID
                         price:(float)price
                      quantity:(int)quantity;
/*!
 * @brief Creates and returns an item instance.
 * @param itemID ID of cart item (consistent with the item column specified in
 * the catalog).
 * @param price Sum total payable for the item, taking into consideration the
 * quantity ordered, and any discounts.
 * @param quantity Quantity in cart.
 */
+ (instancetype)itemWithItemID:(NSString *)itemID
                         price:(float)price
                      quantity:(int)quantity;

/*!
 * @brief ID of cart item (consistent with the item column specified in the
 * catalog).
 */
@property(readonly) NSString *itemID;
/*!
 * @brief Sum total payable for the item, taking into consideration the quantity
 * ordered, and any discounts.
 */
@property(readonly) float price;
/*!
 * @brief Quantity in cart.
 */
@property(readonly) int quantity;

@end

NS_ASSUME_NONNULL_END
