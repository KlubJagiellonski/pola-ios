import Foundation
import UIKit

struct BasketUpdateInfo {
    let removedProductInfo: [String]
    let changedProductAmountInfo: [String]
    let changedProductPriceInfo: [String]
    let changedBrandDeliveryInfo: [String]
}

class BasketDataSource: NSObject, UITableViewDataSource, BasketProductCellDelegate {
    private var productsByBrands: [BasketBrand] = []
    private weak var tableView: UITableView?
    private(set) var lastBasketUpdateInfo: BasketUpdateInfo?
    weak var basketView: BasketView?
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.registerClass(BasketProductCell.self, forCellReuseIdentifier: String(BasketProductCell))
        tableView.registerClass(BasketShippingCell.self, forCellReuseIdentifier: String(BasketShippingCell))
        tableView.registerClass(BasketHeader.self, forHeaderFooterViewReuseIdentifier: String(BasketHeader))
    }
    
    func moveToPosition(at indexPath: NSIndexPath, animated: Bool) {
        guard indexPath.section < productsByBrands.count else {
            logInfo("Cannot scroll to \(indexPath)")
            return
        }
        guard indexPath.row < productsByBrands[indexPath.section].products.count else {
            logInfo("Cannot scroll to \(indexPath)")
            return
        }
        tableView?.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: false)
    }
    
    func updateData(with newProductsByBrands: [BasketBrand]) {
        var removedProductInfo: [String] = []
        var changedProductAmountInfo: [String] = []
        var changedProductPriceInfo: [String] = []
        var changedBrandDeliveryInfo: [String] = []
        
        var addedBrands: [Int] = []
        var removedBrands: [Int] = []
        var updatedBrands: [Int] = []
        
        var addedProducts: [NSIndexPath] = []
        var removedProducts: [NSIndexPath] = []
        var updatedProducts: [NSIndexPath] = []
        
        logInfo("Updating data with old productsByBrands \(productsByBrands), new productsByBrands \(newProductsByBrands)")
        
        // Find removed and updated
        for (brandIndex, oldBrand) in self.productsByBrands.enumerate() {
            if let newBrand = newProductsByBrands.find({ $0.isEqualInBasket(to: oldBrand) }) {
                // Brand has not been removed
                if !newBrand.isEqualExceptProducts(to: oldBrand) {
                    if (newBrand.shippingPrice != oldBrand.shippingPrice && oldBrand.shippingPrice != nil) || (newBrand.waitTime != oldBrand.waitTime && oldBrand.waitTime != nil) {
                        changedBrandDeliveryInfo.append(newBrand.name)
                    }
                    // Brand has been changed
                    updatedBrands.append(brandIndex)
                }
                // Find removed or changed products
                for (productIndex, oldProduct) in oldBrand.products.enumerate() {
                    if let newProduct = newBrand.products.find({ $0.isEqualInBasket(to: oldProduct) }) {
                        // Product has not been removed
                        if newProduct != oldProduct {
                            // Product has been changed
                            if newProduct.amount != oldProduct.amount {
                                changedProductAmountInfo.append(newProduct.name)
                            }
                            if newProduct.price != oldProduct.price {
                                changedProductPriceInfo.append(newProduct.name)
                            }
                            
                            updatedProducts.append(NSIndexPath(forRow: productIndex, inSection: brandIndex))
                        }
                    } else {
                        // Product has been removed
                        removedProductInfo.append(oldProduct.name)
                        removedProducts.append(NSIndexPath(forRow: productIndex, inSection: brandIndex))
                    }
                }
            } else {
                // Brand has been removed
                for oldProduct in oldBrand.products {
                    removedProductInfo.append(oldProduct.name)
                }
                removedBrands.append(brandIndex)
            }
        }
        
        lastBasketUpdateInfo = BasketUpdateInfo(removedProductInfo: removedProductInfo, changedProductAmountInfo: changedProductAmountInfo, changedProductPriceInfo: changedProductPriceInfo, changedBrandDeliveryInfo: changedBrandDeliveryInfo)
        
        // Find added
        for (brandIndex, newBrand) in newProductsByBrands.enumerate() {
            if let oldBrand = self.productsByBrands.find({ $0.isEqualInBasket(to: newBrand) }) {
                // This brand is not new, but we have to check for new products
                for (productIndex, newProduct) in newBrand.products.enumerate() {
                    if !oldBrand.products.contains({ $0.isEqualInBasket(to: newProduct) }) {
                        // This product is new in this brand
                        addedProducts.append(NSIndexPath(forRow: productIndex, inSection: brandIndex))
                    }
                }
            } else {
                // This brand is new, we will add it with its products
                addedBrands.append(brandIndex)
                for (productIndex, _) in newBrand.products.enumerate() {
                    addedProducts.append(NSIndexPath(forRow: productIndex, inSection: brandIndex))
                }
            }
        }
        
        // Update separator visibility for the last cell
        if !removedBrands.isEmpty &&
            removedBrands.contains(self.productsByBrands.count - 1) &&
            !newProductsByBrands.isEmpty {
            // Last section has been removed, so the one before the removed last is the new last
            updatedProducts.append(NSIndexPath(forRow: newProductsByBrands.last!.products.count, inSection: newProductsByBrands.count - 1))
        }
        
        if !addedBrands.isEmpty &&
            addedBrands.contains(newProductsByBrands.count - 1) &&
            !self.productsByBrands.isEmpty {
            // There is a new section at the end, so the previous last section is no longer the last one
            updatedProducts.append(NSIndexPath(forRow: self.productsByBrands.last!.products.count, inSection: self.productsByBrands.count - 1))
        }
        
        self.productsByBrands = newProductsByBrands
        
        if removedBrands.isEmpty &&
            removedProducts.isEmpty &&
            updatedBrands.isEmpty &&
            updatedProducts.isEmpty &&
            addedBrands.isEmpty &&
            addedProducts.isEmpty {
            logInfo("Basket has been updated but nothing changed.")
            return
        }
        logInfo("Updating basket with removed brands \(removedBrands), removed products \(removedProducts), updated brands \(updatedBrands), updated products \(updatedProducts), added brands \(addedBrands), added products \(addedProducts)")
        
        tableView?.beginUpdates()
        
        for brandToRemove in removedBrands {
            tableView?.deleteSections(NSIndexSet(index: brandToRemove), withRowAnimation: .Automatic)
        }
        if !removedProducts.isEmpty {
            tableView?.deleteRowsAtIndexPaths(removedProducts, withRowAnimation: .Automatic)
        }
        for brandToUpdate in updatedBrands {
            tableView?.reloadSections(NSIndexSet(index: brandToUpdate), withRowAnimation: .Automatic)
        }
        if !updatedProducts.isEmpty {
            tableView?.reloadRowsAtIndexPaths(updatedProducts, withRowAnimation: .Automatic)
        }
        for brandToAdd in addedBrands {
            tableView?.insertSections(NSIndexSet(index: brandToAdd), withRowAnimation: .Automatic)
        }
        if !addedProducts.isEmpty {
            tableView?.insertRowsAtIndexPaths(addedProducts, withRowAnimation: .Automatic)
        }
        
        tableView?.endUpdates()
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return productsByBrands.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsByBrands[section].products.count + 1 // 1 for footer
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isFooterCell(indexPath) {
            let brand = productsByBrands[indexPath.section]
            let cell = tableView.dequeueReusableCellWithIdentifier(String(BasketShippingCell)) as! BasketShippingCell
            cell.priceLabel.text = brand.shippingPrice?.stringValue ?? ""
            if let waitTime = brand.waitTime {
                cell.shippingLabel.text = waitTime == 1 ? tr(.CommonDeliveryInfoSingle(String(waitTime))) : tr(.CommonDeliveryInfoMulti(String(waitTime)))
            } else {
                cell.shippingLabel.text = nil
            }
            
            // Hide separator for the last cell
            cell.separatorView.hidden = isLastCell(indexPath)
            return cell;
        } else {
            let product = productsByBrands[indexPath.section].products[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(String(BasketProductCell)) as! BasketProductCell
            cell.updateData(with: product)
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return !isFooterCell(indexPath)
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let product = productsByBrands[indexPath.section].products[indexPath.row]
            basketView?.dataSourceDidDeleteProduct(product)
        }
    }
    
    func titleForHeaderInSection(section: Int) -> String {
        return productsByBrands[section].name
    }
    
    func isFooterCell(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == productsByBrands[indexPath.section].products.count
    }
    
    func isLastCell(indexPath: NSIndexPath) -> Bool {
        return indexPath.section == productsByBrands.count - 1 && indexPath.row == productsByBrands[indexPath.section].products.count
    }
    
    // MARK: - BasketProductCellDelegate
    func basketProductCellDidTapAmount(cell: BasketProductCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else {
            return
        }
        let product = productsByBrands[indexPath.section].products[indexPath.row]
        basketView?.dataSourceDidTapAmount(of: product)
    }
}
