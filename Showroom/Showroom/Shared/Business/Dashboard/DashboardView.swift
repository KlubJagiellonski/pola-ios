import Foundation
import UIKit
import SnapKit
import RxSwift

protocol DashboardViewDelegate: class {
    func dashboardView(dashboardView: DashboardView, didSelectContentPromo contentPromo: ContentPromo)
    func dashboardView(dashboardView: DashboardView, didSelectRecommendation productRecommendation: ProductRecommendation)
}

class DashboardView: UIView, UITableViewDelegate, UICollectionViewDelegate {
    private let tableView = UITableView(frame: CGRectZero, style: .Plain)
    private let dataSource: ContentPromoDataSource
    private let disposeBag = DisposeBag()
    
    var contentInset: UIEdgeInsets {
        get { return tableView.contentInset }
        set {
            tableView.contentInset = newValue
            tableView.scrollIndicatorInsets = newValue
        }
    }
    
    weak var delegate: DashboardViewDelegate?
    
    init(modelState: DashboardModelState) {
        dataSource = ContentPromoDataSource(tableView: tableView)
        
        super.init(frame: CGRectZero)
        
        modelState.recommendationsResultObservable.subscribeNext { [weak self] result in
            guard let recommendations = result?.productRecommendations else { return }
            self?.changeProductRecommendations(recommendations)
        }.addDisposableTo(disposeBag)
        modelState.contentPromoObservable.subscribeNext { [weak self] result in
            guard let promos = result?.contentPromos else { return }
            self?.changeContentPromos(promos)
        }.addDisposableTo(disposeBag)
        modelState.recommendationsIndexObservable.subscribeNext { [weak self] index in
            self?.dataSource.recommendationsDataSource.moveToPosition(atIndex: index, animated: false)
        }.addDisposableTo(disposeBag)
        
        dataSource.recommendationCollectionViewDelegate = self
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.separatorStyle = .None
        addSubview(tableView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeContentPromos(contentPromos: [ContentPromo]) {
        dataSource.changeData(contentPromos)
    }
    
    private func changeProductRecommendations(productRecommendations: [ProductRecommendation]) {
        dataSource.recommendationsDataSource.changeData(productRecommendations)
    }
    
    private func configureCustomConstraints() {
        let superview = self
        
        tableView.snp_makeConstraints { make in
            make.edges.equalTo(superview)
        }
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
