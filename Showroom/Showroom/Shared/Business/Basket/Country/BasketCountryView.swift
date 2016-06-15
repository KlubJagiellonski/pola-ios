import Foundation
import UIKit

protocol BasketCountryViewDelegate: class {
    func countryView(view: BasketCountryView, didSelectCountryAtIndex index: Int)
}

class BasketCountryView: UIView, UITableViewDelegate {
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let topSeparator = UIView()
    private let dataSource: BasketCountryDataSource
    weak var delegate: BasketCountryViewDelegate?
    
    init() {
        dataSource = BasketCountryDataSource(tableView: tableView)
        
        super.init(frame: CGRectZero)
        
        topSeparator.backgroundColor = UIColor(named: .Separator)
        
        tableView.separatorColor = UIColor(named: .Separator)
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        addSubview(topSeparator)
        addSubview(tableView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(with countries: [String]) {
        dataSource.countries = countries
    }
    
    private func configureCustomConstraints() {
        topSeparator.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
        
        tableView.snp_makeConstraints { make in
            make.top.equalTo(topSeparator.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK:- UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        dataSource.updateSelectedIndex(indexPath.row, withNewSelectedCell: tableView.cellForRowAtIndexPath(indexPath))
        
        delegate?.countryView(self, didSelectCountryAtIndex: indexPath.row)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
}
