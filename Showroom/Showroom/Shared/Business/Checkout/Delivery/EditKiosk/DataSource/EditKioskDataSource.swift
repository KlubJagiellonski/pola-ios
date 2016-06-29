import UIKit

class EditKioskDataSource: NSObject, UITableViewDataSource {
    
    var kiosks: [Kiosk] = []
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
        tableView.registerClass(KioskCell.self, forCellReuseIdentifier: String(KioskCell))
    }
    
    func updateData(kiosks: [Kiosk]) {
        self.kiosks = kiosks
        tableView!.reloadData()
    }
    
    func data(forIndexPath indexPath: NSIndexPath) -> Kiosk? {
        return kiosks[indexPath.row]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kiosks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(KioskCell), forIndexPath: indexPath) as! KioskCell
        cell.selectionStyle = .None
        
        let data = kiosks[indexPath.row]
        cell.updateData(data)        
        cell.selected = indexPath.row == selectedIndex
        
        return cell
    }
    
    func getHeightForRow(atIndexPath indexPath: NSIndexPath, cellWidth: CGFloat) -> CGFloat {
        let kiosk = kiosks[indexPath.row]
        return KioskCell.height(forKiosk: kiosk, cellWidth: cellWidth)
    }
    
}