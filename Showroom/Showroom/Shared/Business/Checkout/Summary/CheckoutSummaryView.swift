import Foundation
import UIKit

protocol CheckoutSummaryViewDelegate: class {
    func checkoutSummaryView(view: CheckoutSummaryView, didTapAddCommentAt index: Int)
    func checkoutSummaryView(view: CheckoutSummaryView, didTapEditCommentAt index: Int)
    func checkoutSummaryView(view: CheckoutSummaryView, didTapDeleteCommentAt index: Int)
    func checkoutSummaryViewDidTapBuy(view: CheckoutSummaryView)
}

final class CheckoutSummaryView: UIView, UITableViewDelegate {
    private let dataSource: CheckoutSummaryDataSource;
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let buyButton = UIButton()
    
    weak var delegate: CheckoutSummaryViewDelegate?
    
    init() {
        dataSource = CheckoutSummaryDataSource(tableView: tableView)
        super.init(frame: CGRectZero)
        
        dataSource.summaryView = self;
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .None
        
        buyButton.setTitle(tr(.CheckoutSummaryBuy), forState: .Normal)
        buyButton.applyBlueStyle()
        buyButton.addTarget(self, action: #selector(CheckoutSummaryView.didTapBuy), forControlEvents: .TouchUpInside)
        
        backgroundColor = UIColor(named: .White)
        
        addSubview(tableView)
        addSubview(buyButton)
        
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
    
    func updateData(with basket: Basket?, carrier deliveryCarrier: DeliveryCarrier?, discountCode: String?, comments: [String?]?) {
        guard let basket = basket else { return }
        guard let deliveryCarrier = deliveryCarrier else { return }
    
        dataSource.updateData(with: basket, carrier: deliveryCarrier, discountCode: discountCode, comments: comments)
    }
    
    func updateData(withComments comments: [String?]) {
        dataSource.updateData(withComments: comments)
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
}