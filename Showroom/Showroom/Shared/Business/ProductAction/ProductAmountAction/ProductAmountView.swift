import Foundation
import UIKit

protocol ProductAmountViewDelegate: class {
    func productAmount(view: ProductAmountView, didSelectAmount amount: Int)
}

class ProductAmountView: UIView, UITableViewDelegate {
    private let rowHeight: CGFloat = 33
    
    private let headerView = ProductAmountHeaderView()
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let dataSource: ProductAmountDataSource
    
    weak var delegate: ProductAmountViewDelegate?
    var selectedIndex: Int? {
        set { dataSource.selectedIndex = newValue }
        get { return dataSource.selectedIndex }
    }
    
    init() {
        dataSource = ProductAmountDataSource(tableView: tableView)
        
        super.init(frame: CGRectZero)
        
        layer.shadowColor = UIColor(named: .Black).CGColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3;
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.masksToBounds = false
        
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.clipsToBounds = true
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        
        addSubview(headerView)
        addSubview(tableView)
        
        createCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(withMaxAmount maxAmount: Int) {
        dataSource.updateData(withMaxAmount: maxAmount)
    }
    
    private func createCustomConstraints() {
        headerView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        tableView.snp_makeConstraints { make in
            make.top.equalTo(headerView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dataSource.selectedIndex = indexPath.row
        delegate?.productAmount(self, didSelectAmount: indexPath.row)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
}