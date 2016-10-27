import Foundation
import UIKit
import SnapKit
import RxSwift

protocol DashboardViewDelegate: ViewSwitcherDelegate {
    func dashboardView(dashboardView: DashboardView, didSelectContentPromo contentPromo: ContentPromo)
    func dashboardView(dashboardView: DashboardView, didSelectRecommendation productRecommendation: ProductRecommendation)
    func dashboardViewDidTapRetryRecommendation(dashboardView: DashboardView)
}

class DashboardView: ViewSwitcher, ContentInsetHandler, UITableViewDelegate, UICollectionViewDelegate {
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let dataSource: ContentPromoDataSource
    private let disposeBag = DisposeBag()
    
    var contentInset: UIEdgeInsets = UIEdgeInsetsZero {
        didSet {
            guard contentInset != oldValue else { return }
            tableView.contentInset = UIEdgeInsetsMake(0, contentInset.left, contentInset.bottom, contentInset.right)
            tableView.scrollIndicatorInsets = tableView.contentInset
        }
    }
    
    var recommendationImageWidth: Int {
        return dataSource.recommendationsDataSource.imageWidth
    }
    
    var recommendationViewSwitcherState: ViewSwitcherState {
        get { return dataSource.recommendationsDataSource.viewSwitcherState }
        set { dataSource.recommendationsDataSource.viewSwitcherState = newValue }
    }
    
    weak var delegate: DashboardViewDelegate? {
        didSet {
            switcherDelegate = delegate
        }
    }
    
    init() {
        dataSource = ContentPromoDataSource(tableView: tableView)
        
        super.init(successView: tableView)
        
        switcherDataSource = self
        dataSource.recommendationsDataSource.viewSwitcherDataSource = self
        dataSource.recommendationsDataSource.viewSwitcherDelegate = self
        dataSource.recommendationCollectionViewDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .None
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func recommendationsImageTag(forIndex index: Int) -> Int {
        return dataSource.recommendationsDataSource.imageTag(forIndex: index)
    }
    
    func contentPromosImageTag(forIndex index: Int) -> Int {
        return dataSource.imageTag(forIndex: index)
    }
    
    func refreshImagesIfNeeded() {
        dataSource.refreshImagesIfNeeded()
    }
    
    func changeContentPromos(contentPromos: [ContentPromo]) {
        dataSource.changeData(contentPromos)
    }
    
    func changeProductRecommendations(productRecommendations: [ProductRecommendation]) {
        dataSource.recommendationsDataSource.changeData(productRecommendations)
    }
    
    func moveToRecommendation(atIndex index: Int) {
        dataSource.recommendationsDataSource.moveToPosition(atIndex: index, animated: false)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return dataSource.getHeightForRow(atIndexPath: indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let contentPromo = dataSource.getDataForRow(atIndexPath: indexPath) else { return }
        delegate?.dashboardView(self, didSelectContentPromo: contentPromo)
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let recommendation = dataSource.recommendationsDataSource.getDataForRow(atIndexPath: indexPath)
        delegate?.dashboardView(self, didSelectRecommendation: recommendation)
    }
}

extension DashboardView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        if view == self {
            return ErrorView(errorText: tr(.CommonError), errorImage: UIImage(asset: .Error))
        } else {
            return ErrorView(errorText: tr(.CommonError), errorImage: nil)
        }
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? { return nil }
}

// handling view switcher delegate for recommendations
extension DashboardView: ViewSwitcherDelegate {
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        delegate?.dashboardViewDidTapRetryRecommendation(self)
    }
}
