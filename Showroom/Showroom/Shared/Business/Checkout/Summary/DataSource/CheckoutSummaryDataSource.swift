import Foundation
import UIKit

enum CheckoutSummaryPaymentRow: Int {
    case Payment = 0, BuyButton
    
    static var count: Int { return CheckoutSummaryPaymentRow.BuyButton.rawValue + 1 }
}

class CheckoutSummaryDataSource: NSObject, UITableViewDataSource, CheckoutSummaryCommentCellDelegate {
    private var productsByBrands: [BasketBrand] = []
    private var totalPrice: Money = Money()
    private var totalBasePrice: Money = Money()
    private var comments: [String?]?
    private var delivery: DeliveryType = .UPS
    private weak var tableView: UITableView?
    weak var summaryView: CheckoutSummaryView?
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.registerClass(CheckoutSummaryCell.self, forCellReuseIdentifier: String(CheckoutSummaryCell))
        tableView.registerClass(CheckoutSummaryBrandCell.self, forCellReuseIdentifier: String(CheckoutSummaryBrandCell))
        tableView.registerClass(CheckoutSummaryCommentCell.self, forCellReuseIdentifier: String(CheckoutSummaryCommentCell))
        tableView.registerClass(CheckoutSummaryPaymentCell.self, forCellReuseIdentifier: String(CheckoutSummaryPaymentCell))
        tableView.registerClass(CheckoutSummaryBuyCell.self, forCellReuseIdentifier: String(CheckoutSummaryBuyCell))
    }
    
    func updateData(with basket: Basket, comments: [String?]? = nil, delivery: DeliveryType = .UPS) {
        self.productsByBrands = basket.productsByBrands
        self.totalPrice = basket.price
        self.totalBasePrice = basket.basePrice
        self.comments = comments
        self.delivery = delivery
        
        tableView?.reloadData()
    }
    
    func updateData(withComments comments: [String?]?) {
        self.comments = comments
        tableView?.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return productsByBrands.count + 1 // 1 additional section for payment info
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPaymentSection(section) {
            return 2 // 1 for payment view + 1 for buy button
        } else {
            return productsByBrands[section].products.count + 3 // 3 additional cells: brand, delivery, user comment
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isPaymentSection(indexPath.section) {
            guard let paymentRow = CheckoutSummaryPaymentRow(rawValue: indexPath.row) else {
                fatalError("Could not create cell view, because given row number is not valid for payment section.")
            }
            switch paymentRow {
            case CheckoutSummaryPaymentRow.Payment:
                let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryPaymentCell)) as! CheckoutSummaryPaymentCell
                cell.updateData(withTotalPrice: totalPrice, totalBasePrice: totalBasePrice)
                return cell
            case CheckoutSummaryPaymentRow.BuyButton:
                let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryBuyCell)) as! CheckoutSummaryBuyCell
                return cell
            }
        } else {
            if isBrandCell(at: indexPath) {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryBrandCell)) as! CheckoutSummaryBrandCell
                let brand = productsByBrands[indexPath.section]
                cell.headerLabel.text = brand.name
                return cell
            } else if isDeliveryCell(at: indexPath) {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryCell)) as! CheckoutSummaryCell
                let brand = productsByBrands[indexPath.section]
                cell.updateData(with: brand, delivery: delivery)
                return cell
            } else if isCommentCell(at: indexPath) {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryCommentCell)) as! CheckoutSummaryCommentCell
                cell.delegate = self
                cell.updateData(withComment: comment(forSection: indexPath.section))
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryCell)) as! CheckoutSummaryCell
                let product = productsByBrands[indexPath.section].products[indexPath.row - 1]
                cell.updateData(with: product)
                return cell
            }
        }
    }
    
    // MARK: - Helpers
    
    func heightForRow(at indexPath: NSIndexPath) -> CGFloat {
        if isPaymentSection(indexPath.section) {
            guard let paymentRow = CheckoutSummaryPaymentRow(rawValue: indexPath.row) else {
                fatalError("Could not obtain cell height, because given row number is not valid for payment section.")
            }
            switch paymentRow {
            case CheckoutSummaryPaymentRow.Payment:
                return CheckoutSummaryPaymentCell.getHeight(forBasePrice: totalBasePrice, discountedPrice: totalPrice)
            case CheckoutSummaryPaymentRow.BuyButton:
                return CheckoutSummaryBuyCell.cellHeight
            }
        } else {
            if isBrandCell(at: indexPath) {
                return CheckoutSummaryBrandCell.cellHeight
            } else if isDeliveryCell(at: indexPath) {
                return CheckoutSummaryCell.deliveryCellHeight
            } else if isCommentCell(at: indexPath) {
                guard let width = tableView?.frame.size.width else {
                    return 0.0
                }
                return CheckoutSummaryCommentCell.getHeight(forWidth: width, comment: comment(forSection: indexPath.section))
            } else { // it's a product cell
                return CheckoutSummaryCell.productCellHeight
            }
        }
    }
    
    func isPaymentSection(section: Int) -> Bool {
        return section == productsByBrands.count
    }
    
    func isBrandCell(at indexPath: NSIndexPath) -> Bool {
        return indexPath.row == 0
    }
    
    func isDeliveryCell(at indexPath: NSIndexPath) -> Bool {
        return indexPath.row == productsByBrands[indexPath.section].products.count + 1
    }
    
    func isCommentCell(at indexPath: NSIndexPath) -> Bool {
        return indexPath.row == productsByBrands[indexPath.section].products.count + 2
    }
    
    func comment(forSection section: Int) -> String? {
        return comments != nil && comments!.count > section ? comments![section] : nil
    }

    // MARK: - CheckoutSummaryCommentCellDelegate
    
    func checkoutSummaryCommentCellDidTapAdd(cell: CheckoutSummaryCommentCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else {
            return
        }
        if isPaymentSection(indexPath.section) {
            fatalError("Could not find brand, because given index path points at payment section")
        }
        summaryView?.checkoutSummaryCommentCellDidTapAddComment(at: indexPath.section)
    }
    
    func checkoutSummaryCommentCellDidTapEdit(cell: CheckoutSummaryCommentCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else {
            return
        }
        if isPaymentSection(indexPath.section) {
            fatalError("Could not find brand, because given index path points at payment section")
        }
        summaryView?.checkoutSummaryCommentCellDidTapEditComment(at: indexPath.section)
    }
    
    func checkoutSummaryCommentCellDidTapDelete(cell: CheckoutSummaryCommentCell) {
        guard let indexPath = tableView?.indexPathForCell(cell) else {
            return
        }
        if isPaymentSection(indexPath.section) {
            fatalError("Could not find brand, because given index path points at payment section")
        }
        summaryView?.checkoutSummaryCommentCellDidTapDeleteComment(at: indexPath.section)
    }
}
