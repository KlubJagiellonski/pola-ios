import Foundation
import UIKit

class CheckoutSummaryView: UIView, UITableViewDelegate {
    private let dataSource: CheckoutSummaryDataSource;
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let topSeparator = UIView()
    
    init() {
        dataSource = CheckoutSummaryDataSource(tableView: tableView)
        super.init(frame: CGRectZero)
        
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
        
        dataSource.updateData(with: basket)
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dataSource.heightForRow(at: indexPath)
    }
}