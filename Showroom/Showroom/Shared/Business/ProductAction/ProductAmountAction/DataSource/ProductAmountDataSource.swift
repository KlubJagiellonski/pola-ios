import UIKit

class ProductAmountDataSource: NSObject, UITableViewDataSource {
    private var maxAmount: Int = Constants.basketProductAmountLimit
    private weak var tableView: UITableView?
    
    var selectedIndex: Int? {
        didSet {
            var itemsToReload: [NSIndexPath] = []
            if let old = oldValue {
                itemsToReload.append(NSIndexPath(forRow: old, inSection: 0))
            }
            if let new = selectedIndex {
                itemsToReload.append(NSIndexPath(forRow: new, inSection: 0))
            }
            tableView?.reloadRowsAtIndexPaths(itemsToReload, withRowAnimation: .None)
        }
    }
    
    init (tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        tableView.registerClass(ProductAmountCell.self, forCellReuseIdentifier: String(ProductAmountCell))
    }
    
    func updateData(withMaxAmount maxAmount: Int) {
        self.maxAmount = maxAmount
        tableView?.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return maxAmount + 1 // +1 for amount 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductAmountCell), forIndexPath: indexPath) as! ProductAmountCell
        cell.selectionStyle = .None
        cell.updateData(withAmount: indexPath.row)
        
        if indexPath.row == selectedIndex {
            cell.accessoryView = UIImageView(image: UIImage(named: "ic_tick"))
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
}
