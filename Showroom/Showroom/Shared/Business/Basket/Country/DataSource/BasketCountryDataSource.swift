import Foundation
import UIKit

class BasketCountryDataSource: NSObject, UITableViewDataSource {
    private weak var tableView: UITableView?
    
    var countries: [String] = [] {
        didSet {
            tableView?.reloadData()
        }
    }
    
    var selectedIndex: Int? {
        didSet {
            if let oldSelectedIndex = oldValue {
                tableView?.reloadRowsAtIndexPaths([NSIndexPath(forRow: oldSelectedIndex, inSection: 0)], withRowAnimation: .None)
            }
        }
    }
    
    init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        tableView.registerClass(BasketCountryCell.self, forCellReuseIdentifier: String(BasketCountryCell))
    }
    
    func updateSelectedIndex(index: Int, withNewSelectedCell cell: UITableViewCell?) {
        guard let basketCell = cell as? BasketCountryCell else { return }
        basketCell.ticked = true
        selectedIndex = index
    }
    
    // MARK:- UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(BasketCountryCell), forIndexPath: indexPath) as! BasketCountryCell
        cell.countryNameLabel.text = countries[indexPath.row]
        cell.ticked = indexPath.row == selectedIndex
        return cell
    }

}
