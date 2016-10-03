import UIKit

protocol WishlistViewDelegate: ViewSwitcherDelegate {
    func wishlistView(view: WishlistView, wantsDelete product: WishlistProduct)
    func wishlistView(view: WishlistView, didSelectProductAt indexPath: NSIndexPath)
    func wishlistView(view: WishlistView, widthForDeleteActionViewForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
}

final class WishlistView: ViewSwitcher, ContentInsetHandler, UITableViewDelegate {
    private let dataSource: WishlistDataSource
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    weak var delegate: WishlistViewDelegate? {
        didSet { switcherDelegate = delegate }
    }
    
    var contentInset: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            guard contentInset != oldValue else { return }
            
            tableView.contentInset = UIEdgeInsetsMake(contentInset.top, 0, contentInset.bottom, 0)
            tableView.contentOffset = CGPoint(x: 0, y: -tableView.contentInset.top)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
    
    init() {
        dataSource = WishlistDataSource(tableView: tableView)
        super.init(successView: tableView)
        
        dataSource.delegate = self
        switcherDataSource = self
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        if let selectedRow = tableView.indexPathForSelectedRow where newWindow != nil {
            tableView.deselectRowAtIndexPath(selectedRow, animated: true)
        }
    }
    
    func updateData(with products: [WishlistProduct], animated: Bool) {
        dataSource.updateData(with: products, animated: animated)
    }
    
    func moveToPosition(at index: Int, animated: Bool) {
        dataSource.moveToPosition(at: index, animated: animated)
    }
    
    func refreshImagesIfNeeded() {
        dataSource.refreshImagesIfNeeded()
    }
    
    // MARK:- UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return WishlistCell.cellHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate?.wishlistView(self, didSelectProductAt: indexPath)
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .Default, title: nil, handler: { (action, indexPath) in
            self.tableView.dataSource?.tableView?(self.tableView, commitEditingStyle: .Delete, forRowAtIndexPath: indexPath)
        })

        let deleteIconImage = UIImage(asset: .Ic_kosz)
        guard let width = delegate?.wishlistView(self, widthForDeleteActionViewForRowAtIndexPath: indexPath) else {
            logError("Delegate not set. Unable to view edit actions.")
            return nil
        }
        let height = self.tableView(self.tableView, heightForRowAtIndexPath: indexPath)
        let size = CGSize(width: width, height: height)
        let deleteIconWithBackgroundImage = UIImage.centeredImage(deleteIconImage, size: size, offsetY: -10, backgroundColor: UIColor(named: .RedViolet))
        deleteButton.backgroundColor = UIColor(patternImage: deleteIconWithBackgroundImage)
        
        // New line characters allow to move the title label lower.
        deleteButton.title = "\r\n\r\n" + tr(.WishlistDelete)
        
        return [deleteButton]
    }
}

extension WishlistView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), nil)
    }
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        let emptyView = WishlistEmptyView(contentInset: tableView.contentInset)
        return emptyView
    }
}

extension WishlistView: WishlistDataSourceDelegate {
    func wishlistDataSource(dataSource: WishlistDataSource, wantsDelete product: WishlistProduct) {
        delegate?.wishlistView(self, wantsDelete: product)
    }
}

final class WishlistEmptyView: UIView {
    private let label = UILabel()
    private let doubleTapAnimation = OnboardingDoubleTapAnimation()
    
    init(contentInset: UIEdgeInsets) {
        super.init(frame: CGRectZero)
        
        label.text = tr(L10n.WishlistEmptyDescription)
        label.font = UIFont(fontType: .Onboarding)
        label.numberOfLines = 0
        label.textAlignment = .Center
        label.lineBreakMode = .ByWordWrapping
        
        addSubview(label)
        addSubview(doubleTapAnimation)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        label.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(94)
            make.left.equalToSuperview().inset(24)
            make.right.equalToSuperview().inset(24)
        }
        
        doubleTapAnimation.snp_makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(181.2, 0, 0, 0))
        }
    }
    
    override func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        doubleTapAnimation.animating = newWindow !== nil
    }
}
