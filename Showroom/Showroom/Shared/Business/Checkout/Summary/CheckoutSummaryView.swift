import Foundation
import UIKit

protocol CheckoutSummaryViewDelegate: class {
    func checkoutSummaryViewDidTapAddComment(brand: BasketBrand)
    func checkoutSummaryViewDidTapEditComment(brand: BasketBrand)
    func checkoutSummaryViewDidTapDeleteComment(brand: BasketBrand)
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
    
    func updateData(with basket: Basket?) {
        guard let basket = basket else { return }
        
        // Temporary data for testing
        // TODO: Use real model
        let comments: [String?] = [
            "Proszę o skrócenie nogawek spodni o 3 cm oraz zwężenie ich w pasie o 1 cm.",
            nil
        ]
        dataSource.updateData(with: basket, comments: comments)
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dataSource.heightForRow(at: indexPath)
    }
    
    // MARK: - Brand comments actions
    
    func checkoutSummaryCommentCellDidTapAddComment(to brand: BasketBrand) {
        delegate?.checkoutSummaryViewDidTapAddComment(brand)
    }
    
    func checkoutSummaryCommentCellDidTapEditComment(for brand: BasketBrand) {
        delegate?.checkoutSummaryViewDidTapEditComment(brand)
    }
    
    func checkoutSummaryCommentCellDidTapDeleteComment(from brand: BasketBrand)  {
        delegate?.checkoutSummaryViewDidTapDeleteComment(brand)
    }
}