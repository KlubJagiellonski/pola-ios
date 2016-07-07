import UIKit
import SnapKit

class SettingsView: UIView, UITableViewDelegate {
    static let headerCellHeight: CGFloat = 192.0
    static let cellHeight: CGFloat = 44.0
    
    private let tableView: UITableView
    private let dataSource: SettingsDataSource
    private var topTableViewConstraint: Constraint?
    
    var contentInset: UIEdgeInsets {
        get { return tableView.contentInset }
        set {
            topTableViewConstraint?.updateOffset(newValue.top)
            tableView.contentInset = UIEdgeInsetsMake(0, newValue.left, newValue.bottom, newValue.right)
            tableView.contentOffset = CGPoint(x: 0, y: -newValue.top)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
    
    init() {
        tableView = UITableView(frame: CGRectZero, style: .Plain)
        dataSource = SettingsDataSource(tableView: self.tableView)
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None

        addSubview(tableView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(data: [Setting]) {
        dataSource.updateData(data)
    }
        
    private func configureCustomConstraints() {
        tableView.snp_makeConstraints { make in
            topTableViewConstraint = make.top.equalToSuperview().constraint
            make.bottom.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
    }
    
    // MARK: UITableViewDelegate    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return SettingsView.headerCellHeight
        } else {
            return SettingsView.cellHeight
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let settings = dataSource.settings
        
        if case 3..<settings.count = indexPath.row {
            settings[indexPath.row].action()
        }
    }
}