import Foundation
import UIKit
import RxSwift

class DashboardViewController: UIViewController, DashboardViewDelegate {
    private let model: DashboardModel
    private var castView: DashboardView { return view as! DashboardView }
    
    private let disposeBag = DisposeBag()
    
    init(resolver: DiResolver) {
        self.model = resolver.resolve(DashboardModel.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = DashboardView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        
        model.fetchContentPromo().subscribeNext { [weak self] fetchResult in
            switch fetchResult {
            case .Success(let contentPromoResult):
                self?.castView.changeContentPromos(contentPromoResult.contentPromos)
            case .CacheError(let cacheError):
                logInfo("Error during fetching content promo, cacheError: \(cacheError)")
            case .NetworkError(let networkError):
                logInfo("Error during fetching content promo, networkError: \(networkError)")
            }
        }.addDisposableTo(disposeBag)
        
        model.fetchRecommendations().subscribeNext { [weak self] fetchResult in
            switch fetchResult {
            case .Success(let productRecommendationResult):
                self?.castView.changeProductRecommendations(productRecommendationResult.productRecommendations)
            case .CacheError(let cacheError):
                logInfo("Error during fetching product recommendations, cacheError: \(cacheError)")
            case .NetworkError(let networkError):
                logInfo("Error during fetching product recommendations, networkError: \(networkError)")
            }
        }.addDisposableTo(disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
    }
}