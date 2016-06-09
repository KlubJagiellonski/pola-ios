import UIKit

class ProductSizeDataSource: NSObject, UITableViewDataSource {
    
    private var sizes: [ProductSize] = []
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
    
    init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        tableView.registerClass(ProductSizeCell.self, forCellReuseIdentifier: String(ProductSizeCell))
    }
    
    func updateData(sizes: [ProductSize]) {
        self.sizes = sizes
        tableView?.reloadData()
    }
    
    func data(forIndexPath indexPath: NSIndexPath) -> ProductSize? {
        return sizes[indexPath.row]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sizes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductSizeCell), forIndexPath: indexPath) as! ProductSizeCell
        cell.selectionStyle = .None

        let data = sizes[indexPath.row]
        cell.updateData(data)
        
        if indexPath.row == selectedIndex {
            cell.accessoryView = UIImageView(image: UIImage(named: "ic_tick"))
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
    
}
