import Foundation
import UIKit

class BasketDataSource: NSObject, UITableViewDataSource {
    var items: [String] = ["Małgorzata Salamon", "RISK made in warsaw"]
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
}
