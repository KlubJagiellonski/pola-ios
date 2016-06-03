import Foundation
import UIKit

protocol ProductSizeViewDelegate: class {
    func productSize(view: ProductSizeView, didSelectSize size: String)
    func productSizeDidTapSizes(view: ProductSizeView)
}

class ProductSizeView: UIView, UITableViewDelegate {
    private let rowHeight: CGFloat = 33
    private let separatorHeight: CGFloat = 1
    
    private let headerView = ProductSizeHeaderView()
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let dataSource: ProductSizeDataSource
    
    weak var delegate: ProductSizeViewDelegate?
    
    init() {
        dataSource = ProductSizeDataSource(tableView: tableView)
        
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
        
        headerView.button.addTarget(self, action: #selector(ProductSizeView.didTapSizesButton), forControlEvents: .TouchUpInside)
        
        addSubview(headerView)
        addSubview(tableView)
        
        createCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(data: [ProductSize]) {
        dataSource.updateData(data)
    }
    
    func didTapSizesButton(buttton: UIButton) {
        delegate?.productSizeDidTapSizes(self)
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
        guard let data = dataSource.data(forIndexPath: indexPath) where data.isAvailable else { return }
        dataSource.selectedIndex = indexPath.row
        delegate?.productSize(self, didSelectSize: data.size)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return rowHeight
    }
}