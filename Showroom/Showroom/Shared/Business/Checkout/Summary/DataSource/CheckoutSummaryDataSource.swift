import Foundation
import UIKit

class CheckoutSummaryDataSource: NSObject, UITableViewDataSource, CheckoutSummaryCommentCellDelegate, CheckoutSummaryPaymentOptionCellDelegate {
    private let productsByBrands: [BasketBrand]
    private let totalPrice: Money
    private let totalBasePrice: Money
    private let discount: Money?
    private let discountCode: String?
    private var comments: [String?]?
    private let deliveryCarrier: DeliveryCarrier
    private let payments: [Payment]
    private let selectedPaymentType: PaymentType
    private weak var tableView: UITableView?
    weak var summaryView: CheckoutSummaryView?
    
    var createPayUButton: CGRect -> UIView
    
    init(tableView: UITableView, checkout: Checkout, comments: [String?]?, createPayUButton: CGRect -> UIView) {
        let basket = checkout.basket
        self.productsByBrands = basket.productsByBrands
        self.totalPrice = basket.price
        self.totalBasePrice = basket.basePrice
        self.discount = basket.discount
        self.discountCode = checkout.discountCode
        self.comments = comments
        self.deliveryCarrier = checkout.deliveryCarrier
        let payments = basket.payments.filter { $0.available }
        self.selectedPaymentType = payments.find({ $0.isDefault })?.id ?? payments[0].id
        self.payments = payments
        self.createPayUButton = createPayUButton
        
        super.init()
        
        self.tableView = tableView
        tableView.registerClass(CheckoutSummaryCell.self, forCellReuseIdentifier: String(CheckoutSummaryCell))
        tableView.registerClass(CheckoutSummaryBrandCell.self, forCellReuseIdentifier: String(CheckoutSummaryBrandCell))
        tableView.registerClass(CheckoutSummaryCommentCell.self, forCellReuseIdentifier: String(CheckoutSummaryCommentCell))
        tableView.registerClass(CheckoutSummaryPaymentCell.self, forCellReuseIdentifier: String(CheckoutSummaryPaymentCell))
        tableView.registerClass(CheckoutSummaryPaymentOptionCell.self, forCellReuseIdentifier: String(CheckoutSummaryPaymentOptionCell))
        tableView.registerClass(CheckoutSummaryPayuOptionCell.self, forCellReuseIdentifier: String(CheckoutSummaryPayuOptionCell))
    }
    
    func updateData(withComments comments: [String?]?) {
        self.comments = comments
        tableView?.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return productsByBrands.count + 2 // 2 additional section for payment info and payment options
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isPaymentInfoSection(section) {
            return 1
        } else if isPaymentOptionsSection(section) {
            return payments.count
        } else {
            return productsByBrands[section].products.count + 3 // 3 additional cells: brand, delivery, user comment
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isPaymentInfoSection(indexPath.section) {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryPaymentCell)) as! CheckoutSummaryPaymentCell
            let gratisPayment = payments.find { $0.id == PaymentType.Gratis }
            cell.updateData(withTotalPrice: totalPrice, discount: discount, discountCode: discountCode, gratisAvailable: gratisPayment != nil)
            return cell
        } else if isPaymentOptionsSection(indexPath.section) {
            let payment = payments[indexPath.row]
            
            var cell: CheckoutSummaryPaymentOptionCell!
            if payment.id == PaymentType.PayU {
                let payUCell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryPayuOptionCell)) as! CheckoutSummaryPayuOptionCell
                if payUCell.payUButton == nil {
                    payUCell.payUButton = createPayUButton(CGRectMake(0, 0, payUCell.bounds.width, CheckoutSummaryPayuOptionCell.payUButtonHeight))
                }
                cell = payUCell
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryPaymentOptionCell)) as! CheckoutSummaryPaymentOptionCell
            }
            
            cell.title = payment.name
            cell.optionSelected = selectedPaymentType == payment.id
            cell.delegate = self
            return cell
        } else {
            if isBrandCell(at: indexPath) {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryBrandCell)) as! CheckoutSummaryBrandCell
                let brand = productsByBrands[indexPath.section]
                cell.headerLabel.text = brand.name
                return cell
            } else if isDeliveryCell(at: indexPath) {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryCell)) as! CheckoutSummaryCell
                let brand = productsByBrands[indexPath.section]
                cell.updateData(with: brand, carrier: deliveryCarrier)
                return cell
            } else if isCommentCell(at: indexPath) {
                let cell = tableView.dequeueReusableCellWithIdentifier(String(CheckoutSummaryCommentCell)) as! CheckoutSummaryCommentCell
                cell.delegate = self
                cell.separatorView.hidden = discountCode == nil && isLastBrandSection(indexPath.section)
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
        if isPaymentInfoSection(indexPath.section) {
            return CheckoutSummaryPaymentCell.getHeight(withDiscount: discountCode != nil && discount != nil)
        } else if isPaymentOptionsSection(indexPath.section) {
            let payment = payments[indexPath.row]
            if payment.id == PaymentType.PayU {
                return CheckoutSummaryPayuOptionCell.payUOptionCellHeight
            } else {
                return CheckoutSummaryPaymentOptionCell.height
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
    
    func isPaymentInfoSection(section: Int) -> Bool {
        return section == productsByBrands.count
    }
    
    func isPaymentOptionsSection(section: Int) -> Bool {
        return section == productsByBrands.count + 1
    }
    
    func isLastBrandSection(section: Int) -> Bool {
        return section == productsByBrands.count - 1
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

    func isBrandSection(section: Int) -> Bool {
        return !isPaymentInfoSection(section) && !isPaymentOptionsSection(section)
    }
    
    // MARK: - CheckoutSummaryCommentCellDelegate
    
    func checkoutSummaryCommentCellDidTapAdd(cell: CheckoutSummaryCommentCell) {
        logInfo("Checkout summary comment cell did tap add")
        guard let indexPath = tableView?.indexPathForCell(cell) where isBrandSection(indexPath.section) else {
            logError("Could not find index path for cell: \(cell)")
            return
        }
        summaryView?.checkoutSummaryCommentCellDidTapAddComment(at: indexPath.section)
    }
    
    func checkoutSummaryCommentCellDidTapEdit(cell: CheckoutSummaryCommentCell) {
        logInfo("Checkout summary comment cell did tap edit")
        guard let indexPath = tableView?.indexPathForCell(cell) where isBrandSection(indexPath.section) else {
            logError("Could not find index path for cell: \(cell)")
            return
        }
        summaryView?.checkoutSummaryCommentCellDidTapEditComment(at: indexPath.section)
    }
    
    func checkoutSummaryCommentCellDidTapDelete(cell: CheckoutSummaryCommentCell) {
        logInfo("Checkout summary comment cell did tap delete")
        guard let indexPath = tableView?.indexPathForCell(cell) where isBrandSection(indexPath.section) else {
            logError("Could not find index path for cell: \(cell)")
            return
        }
        summaryView?.checkoutSummaryCommentCellDidTapDeleteComment(at: indexPath.section)
    }
    
    // MARK: - CheckoutSummaryPaymentOptionCellDelegate
    
    func optionCellDidChangeToSelectedState(cell: CheckoutSummaryPaymentOptionCell) {
        guard let tableView = tableView else { return }
        guard let indexPath = tableView.indexPathForCell(cell) where isPaymentOptionsSection(indexPath.section) else {
            logError("Cound not find indexPath or is not payment section: \(tableView.indexPathForCell(cell)) \(productsByBrands.count)")
            return
        }
        summaryView?.checkoutSummaryDidChangeToPaymentType(payments[indexPath.row].id)
        for row in 0...(payments.count - 1) {
            guard row != indexPath.row else { continue }
            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: indexPath.section)) as! CheckoutSummaryPaymentOptionCell
            cell.optionSelected = false
        }
    }
}