import UIKit

protocol WishlistDataSourceDelegate: class {
    func wishlistDataSource(dataSource: WishlistDataSource, wantsDelete product: WishlistProduct)
}

class WishlistDataSource: NSObject, UITableViewDataSource {
    private var products: [WishlistProduct] = []
    private weak var tableView: UITableView?
    weak var delegate: WishlistDataSourceDelegate?
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.registerClass(WishlistCell.self, forCellReuseIdentifier: String(WishlistCell))
    }
    
    func moveToPosition(at index: Int, animated: Bool) {
        guard index < products.count else {
            logInfo("Cannot scroll to \(index)")
            return
        }
        tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: index, inSection: 0), atScrollPosition: .Top, animated: false)
    }
    
    func updateData(with newProducts: [WishlistProduct]) {
        var addedProducts: [NSIndexPath] = []
        var removedProducts: [NSIndexPath] = []
        var updatedProducts: [NSIndexPath] = []
        var movedProducts: [(NSIndexPath, NSIndexPath)] = []
        
        logInfo("Updating newProducts \(newProducts), oldProducts \(products)")
        
        // Find removed and updated
        for (oldIndex, oldProduct) in products.enumerate() {
            
            if let newIndex = newProducts.indexOf({ $0.id == oldProduct.id }) {
                let newProduct = newProducts[newIndex]
                
                // Product has not been removed
                if newProduct != oldProduct {
                    // Product has been changed
                    updatedProducts.append(NSIndexPath(forRow: oldIndex, inSection: 0))
                } else if newIndex != oldIndex {
                    movedProducts.append((NSIndexPath(forRow: oldIndex, inSection: 0), NSIndexPath(forRow: newIndex, inSection: 0)))
                }
            } else {
                // Product has been removed
                removedProducts.append(NSIndexPath(forRow: oldIndex, inSection: 0))
            }
        }
        
        // Find added
        for (productIndex, newProduct) in newProducts.enumerate() {
            if !products.contains({ $0.id == newProduct.id }) {
                // This product is new in this brand
                addedProducts.append(NSIndexPath(forRow: productIndex, inSection: 0))
            }
        }
        
        self.products = newProducts
        
        if removedProducts.isEmpty &&
            updatedProducts.isEmpty &&
            addedProducts.isEmpty &&
            movedProducts.isEmpty {
            logInfo("Wishlist has been updated but nothing changed.")
            return
        }
        
        logInfo("Updating tableView with removed \(removedProducts), updated \(updatedProducts), added \(addedProducts), moved \(movedProducts)")
        
        // checking for incostinstency
        for adddedProduct in addedProducts {
            for movedProduct in movedProducts {
                if adddedProduct.row == movedProduct.1.row {
                    logError("Found incostinstency. Cannot move and add to same index")
                    tableView?.reloadData()
                    return
                }
            }
        }
        
        
        tableView?.beginUpdates()
        
        if !movedProducts.isEmpty {
            for movedProduct in movedProducts {
                tableView?.moveRowAtIndexPath(movedProduct.0, toIndexPath: movedProduct.1)
            }
        }
        
        if !removedProducts.isEmpty {
            tableView?.deleteRowsAtIndexPaths(removedProducts, withRowAnimation: .Automatic)
        }
        if !updatedProducts.isEmpty {
            tableView?.reloadRowsAtIndexPaths(updatedProducts, withRowAnimation: .Automatic)
        }
        if !addedProducts.isEmpty {
            tableView?.insertRowsAtIndexPaths(addedProducts, withRowAnimation: .Automatic)
        }
        
        tableView?.endUpdates()
    }
    
    // MARK:- UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(WishlistCell)) as! WishlistCell
        cell.updateData(with: products[indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let product = products[indexPath.row]
            delegate?.wishlistDataSource(self, wantsDelete: product)
        }
    }
}
