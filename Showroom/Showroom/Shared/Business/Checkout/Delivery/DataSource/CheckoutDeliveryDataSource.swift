import UIKit

enum Delivery { case Courier, Kiosk }

class CheckoutDeliveryDataSource: NSObject, UITableViewDataSource {
    
    private weak var tableView: UITableView?
    
    let delivery: Delivery
    
    init(tableView: UITableView, delivery: Delivery) {
        self.delivery = delivery
        super.init()
        
        self.tableView = tableView
        tableView.registerClass(CheckoutDeliveryInfoHeaderCell.self, forCellReuseIdentifier: String(CheckoutDeliveryInfoHeaderCell))
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutDeliveryInfoHeaderCell)) as! CheckoutDeliveryInfoHeaderCell

        switch delivery {
        case .Courier: cell.label.text = tr(.CheckoutDeliveryCourierHeader)
        case .Kiosk: cell.label.text = tr(.CheckoutDeliveryRUCHHeader)
        }

        return cell
    }
}
