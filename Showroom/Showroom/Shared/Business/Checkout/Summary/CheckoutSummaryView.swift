import Foundation
import UIKit

protocol CheckoutSummaryViewDelegate: class {
    func checkoutSummaryView(view: CheckoutSummaryView, didTapAddCommentAt index: Int)
    func checkoutSummaryView(view: CheckoutSummaryView, didTapEditCommentAt index: Int)
    func checkoutSummaryView(view: CheckoutSummaryView, didTapDeleteCommentAt index: Int)
    func checkoutSummaryView(view: CheckoutSummaryView, didSelectPaymentWithType type: PaymentType)
    func checkoutSummaryViewDidTapBuy(view: CheckoutSummaryView)
}

final class CheckoutSummaryView: ViewSwitcher, UITableViewDelegate {
    private let dataSource: CheckoutSummaryDataSource
    private let contentView = UIView()
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let buyButton = UIButton()
    
    weak var delegate: CheckoutSummaryViewDelegate?
    
    init(with checkout: Checkout, comments: [String?]?, createPayUButton: CGRect -> UIView) {
        dataSource = CheckoutSummaryDataSource(tableView: tableView, checkout: checkout, comments: comments, createPayUButton: createPayUButton)
        super.init(successView: contentView, initialState: .Success)
        
        dataSource.summaryView = self;
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .None
        
        buyButton.enabled = false
        buyButton.setTitle(tr(.CheckoutSummaryBuy), forState: .Normal)
        buyButton.applyBlueStyle()
        buyButton.addTarget(self, action: #selector(CheckoutSummaryView.didTapBuy), forControlEvents: .TouchUpInside)
        
        backgroundColor = UIColor(named: .White)
        
        contentView.addSubview(tableView)
        contentView.addSubview(buyButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        tableView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalTo(buyButton.snp_top)
        }
        
        buyButton.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
    }
    
    func updateData(withComments comments: [String?]) {
        dataSource.updateData(withComments: comments)
    }
    
    func update(buyButtonEnabled enabled: Bool) {
        buyButton.enabled = enabled
    }
    
    func didTapBuy() {
        delegate?.checkoutSummaryViewDidTapBuy(self)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dataSource.heightForRow(at: indexPath)
    }
    
    // MARK: - Brand comments actions
    
    func checkoutSummaryCommentCellDidTapAddComment(at index: Int) {
        delegate?.checkoutSummaryView(self, didTapAddCommentAt: index)
    }
    
    func checkoutSummaryCommentCellDidTapEditComment(at index: Int) {
        delegate?.checkoutSummaryView(self, didTapEditCommentAt: index)
    }
    
    func checkoutSummaryCommentCellDidTapDeleteComment(at index: Int) {
        delegate?.checkoutSummaryView(self, didTapDeleteCommentAt: index)
    }
    
    func checkoutSummaryDidChangeToPaymentType(type: PaymentType) {
        delegate?.checkoutSummaryView(self, didSelectPaymentWithType: type)
    }
}