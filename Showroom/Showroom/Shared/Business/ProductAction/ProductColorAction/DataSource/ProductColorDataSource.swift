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
        tableView.registerClass(ImageSmallSelectValuTableViewCell.self, forCellReuseIdentifier: String(ImageSmallSelectValuTableViewCell))
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
        let productColor = colors[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier(String(ImageSmallSelectValuTableViewCell), forIndexPath: indexPath) as! ImageSmallSelectValuTableViewCell
        cell.selectionStyle = .None
        cell.setColorRepresentation(productColor.color)
        cell.setColorAvailability(productColor.isAvailable)
        cell.title = productColor.isAvailable ? String(productColor) : String(productColor) + "\n" + tr(.ProductActionColorCellColorUnavailable)
        cell.selectAccessoryType = indexPath.row == selectedIndex ? .Checkmark : .None
        return cell
    }
}
