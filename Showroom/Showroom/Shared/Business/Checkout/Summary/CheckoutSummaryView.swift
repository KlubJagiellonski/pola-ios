import Foundation
import UIKit

protocol CheckoutSummaryViewDelegate: class {
    func checkoutSummaryView(view: CheckoutSummaryView, didTapAddCommentAt index: Int)
    func checkoutSummaryView(view: CheckoutSummaryView, didTapEditCommentAt index: Int)
    func checkoutSummaryView(view: CheckoutSummaryView, didTapDeleteCommentAt index: Int)
}

class CheckoutSummaryView: UIView, UITableViewDelegate {
    private let dataSource: CheckoutSummaryDataSource;
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let topSeparator = UIView()
    
    weak var delegate: CheckoutSummaryViewDelegate?
    
    init() {
        dataSource = CheckoutSummaryDataSource(tableView: tableView)
        super.init(frame: CGRectZero)
        
        dataSource.summaryView = self;
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .None
        
        topSeparator.backgroundColor = UIColor(named: .Manatee)
        
        backgroundColor = UIColor(named: .White)
        
        addSubview(topSeparator)
        addSubview(tableView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        topSeparator.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
        
        tableView.snp_makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(topSeparator.snp_bottom)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func updateData(with basket: Basket?, carrier deliveryCarrier: DeliveryCarrier?, comments: [String?]?) {
        guard let basket = basket else { return }
        guard let deliveryCarrier = deliveryCarrier else { return }
    
        dataSource.updateData(with: basket, carrier: deliveryCarrier, comments: comments)
    }
    
    func updateData(withComments comments: [String?]) {
        dataSource.updateData(withComments: comments)
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