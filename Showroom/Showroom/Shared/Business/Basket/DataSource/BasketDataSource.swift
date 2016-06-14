import Foundation
import UIKit

class BasketDataSource: NSObject, UITableViewDataSource {
    private var productsByBrands: [BasketBrand] = []
    private weak var tableView: UITableView?
    weak var basketView: BasketView?
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.registerClass(BasketProductCell.self, forCellReuseIdentifier: String(BasketProductCell))
        tableView.registerClass(BasketShippingCell.self, forCellReuseIdentifier: String(BasketShippingCell))
        tableView.registerClass(BasketHeader.self, forHeaderFooterViewReuseIdentifier: String(BasketHeader))
    }
    
    func updateData(with productsByBrands: [BasketBrand]) {
        self.productsByBrands = productsByBrands
        tableView?.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return productsByBrands.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsByBrands[section].products.count + 1 // 1 for footer
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isFooterCell(indexPath) {
            let item = productsByBrands[indexPath.section]
            let cell = tableView.dequeueReusableCellWithIdentifier(String(BasketShippingCell)) as! BasketShippingCell
            cell.priceLabel.text = item.shippingPrice.stringValue
            cell.shippingLabel.text = tr(.BasketShippingIn) + " " + String(item.waitTime) + " " + (item.waitTime == 1 ? tr(.BasketDay) : tr(.BasketDays)) // TODO: Add shipping method
            if isLastCell(indexPath) {
                // Hide separator for the last cell
                cell.separatorView.hidden = true
            }
            return cell;
        } else {
            let item = productsByBrands[indexPath.section].products[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(String(BasketProductCell)) as! BasketProductCell
            cell.updateData(item)
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
}
