import Foundation
import UIKit

class BasketDataSource: NSObject, UITableViewDataSource {
    private var items: [BasketBrand] = BasketDataSource.createSampleData()
    private weak var tableView: UITableView?
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.registerClass(BasketProductCell.self, forCellReuseIdentifier: String(BasketProductCell))
        tableView.registerClass(BasketShippingCell.self, forCellReuseIdentifier: String(BasketShippingCell))
        tableView.registerClass(BasketHeader.self, forHeaderFooterViewReuseIdentifier: String(BasketHeader))
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].products.count + 1 // 1 for footer
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isFooterCell(indexPath) {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(BasketShippingCell)) as! BasketShippingCell
            if isLastCell(indexPath) {
                // Hide separator for the last cell
                cell.separatorView.hidden = true
            }
            return cell;
        } else {
            let item = items[indexPath.section].products[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier(String(BasketProductCell)) as! BasketProductCell
            cell.selectionStyle = .None
            cell.updateData(item)
            return cell
        }
    }
    
    func titleForHeaderInSection(section: Int) -> String {
        return items[section].name
    }
    
    func isFooterCell(indexPath: NSIndexPath) -> Bool {
        return indexPath.row == items[indexPath.section].products.count
    }
    
    func isLastCell(indexPath: NSIndexPath) -> Bool {
        return indexPath.section == items.count - 1 && indexPath.row == items[indexPath.section].products.count
    }
    
    static func createSampleData() -> [BasketBrand] {
        return [
            BasketBrand(name: "Małgorzata Salamon", products: [
                BasketProduct(name: "Sweter Serce z dekoltem na plecach", imageUrl: "https://static.shwrm.net/images/w/8/w8573104cca75da_500x643.jpg", size: "XS", color: "niebieski", price: Money(amt: 400.00), discountPrice: Money(amt: 299.00), amount: 1)]),
            BasketBrand(name: "RISK made in warsaw", products: [
                BasketProduct(name: "Spódnica maxi The Forever Skirt", imageUrl: "https://static.shwrm.net/images/g/t/gt573d85d13b9f7_500x643.jpg", size: "S", color: nil, price: Money(amt: 429.00), discountPrice: nil, amount: 1),
                BasketProduct(name: "Spódnica Inka white", imageUrl: "https://static.shwrm.net/images/w/a/wa572b3deddf05a_500x643.jpg", size: nil, color: "zielony", price: Money(amt: 16.00), discountPrice: nil, amount: 1)])
        ]
    }
}
