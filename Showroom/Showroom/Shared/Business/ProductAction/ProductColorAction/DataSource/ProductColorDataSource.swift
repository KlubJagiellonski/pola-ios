import UIKit

class ProductColorDataSource: NSObject, UITableViewDataSource {
    
    private var colors: [ProductColor] = []
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
        tableView.registerClass(ProductColorCell.self, forCellReuseIdentifier: String(ProductColorCell))
    }
    
    func updateData(colors: [ProductColor]) {
        self.colors = colors
        tableView?.reloadData()
    }
    
    func data(forIndexPath indexPath: NSIndexPath) -> ProductColor? {
        return colors[indexPath.row]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductColorCell), forIndexPath: indexPath) as! ProductColorCell
        cell.selectionStyle = .None
        
        let data = colors[indexPath.row]
        cell.updateData(data)
        
        if indexPath.row == selectedIndex {
            cell.accessoryView = UIImageView(image: UIImage(named: "ic_tick"))
        } else {
            cell.accessoryView = nil
        }
        
        return cell
    }
}
