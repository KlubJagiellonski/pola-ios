import Foundation
import UIKit

enum ProductDescriptionRow: Int {
    case SizeChart = 0, BrandProducts, DeliveryInfo, Description
    
    static var count: Int { return ProductDescriptionRow.Description.rawValue + 1 }
}

class ProductDescriptionDataSource: NSObject, UITableViewDataSource {
    private let simpleCellHeight: CGFloat = 38
    
    private var deliveryWaitTime: Int?
    private var descriptions: [String]?
    
    private weak var tableView: UITableView?
    
    init(tableView: UITableView) {
        super.init()
        
        
        self.tableView = tableView
        tableView.separatorStyle = .None
        tableView.registerClass(ProductDescriptionSimpleCell.self, forCellReuseIdentifier: String(ProductDescriptionSimpleCell))
        tableView.registerClass(ProductDescriptionLineCell.self, forCellReuseIdentifier: String(ProductDescriptionLineCell))
    }
    
    func updateModel(deliveryWaitTime: Int, descriptions: [String]) {
        self.deliveryWaitTime = deliveryWaitTime
        self.descriptions = descriptions
        tableView?.reloadData()
    }
    
    func heightForRow(atIndexPath indexPath: NSIndexPath) -> CGFloat {
        let descriptionRow = ProductDescriptionRow(rawValue: indexPath.row)
        if let _ = descriptionRow {
            return simpleCellHeight
        } else {
            let description = findDescription(forIndexPath: indexPath)
            return ProductDescriptionLineCell.getHeight(forWidth: tableView!.bounds.width, title: description)
        }
    }
    
    // MARK:- UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryWaitTime == nil ? 0 : ProductDescriptionRow.count + descriptions!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let descriptionRow = ProductDescriptionRow(rawValue: indexPath.row)
        
        if let row = descriptionRow {
            switch row {
            case .SizeChart:
                let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductDescriptionSimpleCell), forIndexPath: indexPath) as! ProductDescriptionSimpleCell
                cell.topSeparator.hidden = true
                cell.titleLabel.text = tr(.ProductDetailsSizeChart)
                cell.goImageView.hidden = false
                return cell
            case .BrandProducts:
                let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductDescriptionSimpleCell), forIndexPath: indexPath) as! ProductDescriptionSimpleCell
                cell.topSeparator.hidden = false
                cell.titleLabel.text = tr(.ProductDetailsOtherBrandProducts)
                cell.goImageView.hidden = false
                return cell
            case .DeliveryInfo:
                let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductDescriptionSimpleCell), forIndexPath: indexPath) as! ProductDescriptionSimpleCell
                cell.topSeparator.hidden = false
                cell.titleLabel.text = deliveryWaitTime! == 0 ? tr(.ProductDetailsDeliveryInfoSingle(String(deliveryWaitTime!))) : tr(.ProductDetailsDeliveryInfoMulti(String(deliveryWaitTime!)))
                cell.goImageView.hidden = true
                return cell
            case .Description:
                let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductDescriptionSimpleCell), forIndexPath: indexPath) as! ProductDescriptionSimpleCell
                cell.topSeparator.hidden = false
                cell.titleLabel.text = tr(.ProductDetailsProductDescription)
                cell.goImageView.hidden = true
                return cell
            }
        } else {
            let description = findDescription(forIndexPath: indexPath)
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductDescriptionLineCell), forIndexPath: indexPath) as! ProductDescriptionLineCell
            cell.titleLabel.text = description
            return cell
        }
    }
    
    // MARK:- Helpers
    
    func findDescription(forIndexPath indexPath: NSIndexPath) -> String {
        return descriptions![indexPath.row - ProductDescriptionRow.count]
    }
}
