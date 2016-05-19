import Foundation
import UIKit
import SnapKit

protocol DashboardViewDelegate: class {
    
}

class DashboardView: UIView, UITableViewDelegate {
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    weak var delegate: DashboardViewDelegate?
    
    init(dataSource: DashboardDataSource) {
        super.init(frame: CGRectZero)
        tableView.delegate = self
        tableView.dataSource = dataSource
        addSubview(tableView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCustomConstraints() {
        let superview = self
        
        tableView.snp_makeConstraints { make in
            make.edges.equalTo(superview)
        }
    }
}
