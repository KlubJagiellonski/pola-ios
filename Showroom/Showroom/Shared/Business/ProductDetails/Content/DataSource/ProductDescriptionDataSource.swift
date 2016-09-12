import Foundation
import UIKit

enum ProductDescriptionRow: Int {
    case SizeChart = 0, DeliveryInfo, Description, BrandProducts
    
    func index(forSizeChartVisible sizeChartVisible: Bool) -> Int {
        if sizeChartVisible {
            return rawValue
        } else {
            return rawValue - 1
        }
    }
    
    static func count(forSizeChartVisible sizeChartVisible: Bool) -> Int{
        if sizeChartVisible {
            return ProductDescriptionRow.BrandProducts.rawValue + 1
        } else {
            return ProductDescriptionRow.BrandProducts.rawValue
        }
    }
}

class ProductDescriptionDataSource: NSObject, UITableViewDataSource {
    private let simpleCellHeight: CGFloat = 38
    
    private var deliveryWaitTime: Int?
    private var descriptions: [String]?
    private var brandName: String?
    private var sizeChartVisible = true
    
    private weak var tableView: UITableView?
    
    private var descriptionsFirstIndex: Int {
        if sizeChartVisible {
            return ProductDescriptionRow.Description.rawValue + 1
        } else {
            return ProductDescriptionRow.Description.rawValue
        }
    }
    
    init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        tableView.separatorStyle = .None
        tableView.registerClass(ProductDescriptionSimpleCell.self, forCellReuseIdentifier: String(ProductDescriptionSimpleCell))
        tableView.registerClass(ProductDescriptionLineCell.self, forCellReuseIdentifier: String(ProductDescriptionLineCell))
    }
    
    func updateModel(deliveryWaitTime: Int, descriptions: [String], brandName: String, sizeChartVisible: Bool) {
        self.deliveryWaitTime = deliveryWaitTime
        self.descriptions = descriptions
        self.brandName = brandName
        self.sizeChartVisible = sizeChartVisible
        tableView?.reloadData()
    }
    
    func heightForRow(atIndexPath indexPath: NSIndexPath) -> CGFloat {
        if isDescriptionItem(indexPath.row) {
            let description = findDescription(forIndexPath: indexPath)
            var height = ProductDescriptionLineCell.getHeight(forWidth: tableView!.bounds.width, title: description)
            if isDescriptionLastItem(indexPath.row) {
                height += 8 //we need to add bottom margin for last description item
            }
            return height
        } else {
            return simpleCellHeight
        }
    }
    
    func row(forIndexPath indexPath: NSIndexPath) -> ProductDescriptionRow? {
        if isBrandProducts(withIndex: indexPath.row) {
            return ProductDescriptionRow.BrandProducts
        }
        var index = indexPath.row
        if !sizeChartVisible {
            index += 1
        }
        return ProductDescriptionRow(rawValue: index)
    }
    
    // MARK:- UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryWaitTime == nil ? 0 : ProductDescriptionRow.count(forSizeChartVisible: sizeChartVisible) + descriptions!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        switch indexPath.row {
        case ProductDescriptionRow.SizeChart.index(forSizeChartVisible: sizeChartVisible):
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductDescriptionSimpleCell), forIndexPath: indexPath) as! ProductDescriptionSimpleCell
            cell.bottomSeparator.hidden = false
            cell.topSeparator.hidden = true
            cell.titleLabel.text = tr(.ProductDetailsSizeChart)
            cell.goImageView.hidden = false
            return cell
        case ProductDescriptionRow.DeliveryInfo.index(forSizeChartVisible: sizeChartVisible):
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductDescriptionSimpleCell), forIndexPath: indexPath) as! ProductDescriptionSimpleCell
            cell.bottomSeparator.hidden = false
            cell.topSeparator.hidden = true
            cell.titleLabel.text = deliveryWaitTime! == 0 ? tr(.CommonDeliveryInfoSingle(String(deliveryWaitTime!))) : tr(.CommonDeliveryInfoMulti(String(deliveryWaitTime!)))
            cell.goImageView.hidden = true
            return cell
        case ProductDescriptionRow.Description.index(forSizeChartVisible: sizeChartVisible):
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductDescriptionSimpleCell), forIndexPath: indexPath) as! ProductDescriptionSimpleCell
            cell.bottomSeparator.hidden = true
            cell.topSeparator.hidden = true
            cell.titleLabel.text = tr(.ProductDetailsProductDescription)
            cell.goImageView.hidden = true
            return cell
        case let x where isDescriptionItem(x):
            let description = findDescription(forIndexPath: indexPath)
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductDescriptionLineCell), forIndexPath: indexPath) as! ProductDescriptionLineCell
            cell.titleLabel.text = description
            return cell
        case let x where isBrandProducts(withIndex: x):
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ProductDescriptionSimpleCell), forIndexPath: indexPath) as! ProductDescriptionSimpleCell
            cell.topSeparator.hidden = false
            cell.bottomSeparator.hidden = false
            cell.titleLabel.text = tr(.ProductDetailsOtherBrandProducts(brandName ?? ""))
            cell.goImageView.hidden = false
            return cell
        default:
            fatalError("No cell created for indexPath: \(indexPath)")
        }
    }
    
    // MARK:- Helpers
    
    func isDescriptionItem(index: Int) -> Bool {
        return index >= descriptionsFirstIndex && index < (descriptionsFirstIndex + descriptions!.count)
    }
    
    func isDescriptionLastItem(index: Int) -> Bool {
        return index == (descriptionsFirstIndex + descriptions!.count - 1)
    }
    
    func findDescription(forIndexPath indexPath: NSIndexPath) -> String {
        return descriptions![indexPath.row - descriptionsFirstIndex]
    }
    
    func isBrandProducts(withIndex index: Int) -> Bool {
        return index == ProductDescriptionRow.count(forSizeChartVisible: sizeChartVisible) + descriptions!.count - 1
    }
}
