import Foundation
import UIKit
import RxSwift

class DashboardViewController: UIViewController, DashboardViewDelegate {
    private let model: DashboardModel
    private var castView: DashboardView { return view as! DashboardView }
    
    private let resolver: DiResolver
    private let disposeBag = DisposeBag()
    
    init(resolver: DiResolver) {
        self.resolver = resolver
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
        
        automaticallyAdjustsScrollViewInsets = false
        
        castView.delegate = self
        
        castView.changeProductRecommendations(model.state.recommendationsResult?.productRecommendations ?? [])
        castView.recommendationViewSwitcherState = model.state.recommendationsResult?.productRecommendations == nil ? .Loading : .Success
        
        castView.changeContentPromos(model.state.contentPromoResult?.contentPromos ?? [])
        castView.changeSwitcherState(model.state.contentPromoResult?.contentPromos == nil ? .Loading : .Success, animated: false)
        
        model.state.recommendationsResultObservable.subscribeNext { [weak self] result in
            guard let `self` = self else { return }
            self.castView.changeProductRecommendations(result?.productRecommendations ?? [])
        }.addDisposableTo(disposeBag)
        
        model.state.contentPromoObservable.subscribeNext { [weak self] result in
            guard let `self` = self else { return }
            self.castView.changeContentPromos(result?.contentPromos ?? [])
        }.addDisposableTo(disposeBag)
        
        model.state.recommendationsIndexObservable.subscribeNext { [weak self] index in
            guard let `self` = self, let index = index else { return }
            self.castView.moveToRecommendation(atIndex: index)
        }.addDisposableTo(disposeBag)
        
        model.triggerFetchContentPromoObservable.subscribeNext { [weak self] in
            guard let `self` = self else { return }
            if self.model.state.contentPromoResult == nil {
                self.castView.changeSwitcherState(.Loading)
            }
            self.fetchContentPromo()
        }.addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.Dashboard)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        markHandoffUrlActivity(withPathComponent: "", resolver: resolver)
        castView.refreshImagesIfNeeded()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.contentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
    }
    
    func updateData() {
        logInfo("Updating data")
        fetchContentPromo()
        fetchRecommendations()
    }
    
    private func fetchContentPromo() {
        logInfo("Fetching content promo")
        model.fetchContentPromo().subscribeNext { [weak self] fetchResult in
            guard let `self` = self else { return }
            switch fetchResult {
            case .Success(let contentPromoResult):
                logInfo("Fetched content promo: \(contentPromoResult)")
                self.castView.changeSwitcherState(.Success)
            case .CacheError(let cacheError):
                logError("Error during fetching content promo, cacheError: \(cacheError)")
            case .NetworkError(let networkError):
                logInfo("Error during fetching content promo, networkError: \(networkError)")
                if self.model.state.contentPromoResult == nil {
                    self.castView.changeSwitcherState(.Error)
                }
            }
        }.addDisposableTo(disposeBag)
    }
    
    private func fetchRecommendations() {
        logInfo("Fetching recommendations")
        model.fetchRecommendations().subscribeNext { [weak self] fetchResult in
            guard let strongSelf = self else { return }
            switch fetchResult {
            case .Success(let productRecommendationResult):
                logInfo("Fetched product recommendations: \(productRecommendationResult)")
                strongSelf.castView.recommendationViewSwitcherState = .Success
            case .CacheError(let cacheError):
                logError("Error during fetching product recommendations, cacheError: \(cacheError)")
            case .NetworkError(let networkError):
                logInfo("Error during fetching product recommendations, networkError: \(networkError)")
                if strongSelf.model.state.recommendationsResult == nil {
                    strongSelf.castView.recommendationViewSwitcherState = .Error
                }
            }
        }.addDisposableTo(disposeBag)
    }
    
    // MARK: - DashboardViewDelegate
    
    func dashboardView(dashboardView: DashboardView, didSelectContentPromo contentPromo: ContentPromo) {
        logInfo("Did select content promo \(contentPromo)")
        logAnalyticsEvent(AnalyticsEventId.DashboardContentPromoClicked(contentPromo.link, model.state.contentPromoResult?.contentPromos.indexOf(contentPromo) ?? 0))
        sendNavigationEvent(ShowItemForLinkEvent(link: contentPromo.link, title: nil, productDetailsFromType: .HomeContentPromo))
    }
    
    func dashboardView(dashboardView: DashboardView, didSelectRecommendation productRecommendation: ProductRecommendation) {
        logInfo("Did select recommendation \(productRecommendation)")
        logAnalyticsEvent(AnalyticsEventId.DashboardRecommendationClicked(productRecommendation.itemId, model.state.recommendationsResult?.productRecommendations.indexOf(productRecommendation) ?? 0))
        
        let imageWidth = dashboardView.recommendationImageWidth
        let context = model.createProductDetailsContext(forRecommendation: productRecommendation, withImageWidth: imageWidth)
        let retrieveCurrentImageViewTag: () -> Int? = { [weak self] in
            guard let `self` = self else { return nil }
            guard let index = self.model.state.recommendationsIndex else { return nil }
            logInfo("Retrieving current image view tag for index \(index)")
            return self.castView.imageTag(forIndex: index)
        }
        sendNavigationEvent(ShowProductDetailsEvent(context: context, retrieveCurrentImageViewTag: retrieveCurrentImageViewTag))
    }
    
    func dashboardViewDidTapRetryRecommendation(dashboardView: DashboardView) {
        logInfo("Did tap retry recommendation")
        castView.recommendationViewSwitcherState = .Loading
        fetchRecommendations()
    }
    
    // MARK: - ViewSwitchedDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("Did tap retry")
        castView.changeSwitcherState(.Loading)
        fetchContentPromo()
        if castView.recommendationViewSwitcherState == .Error {
            castView.recommendationViewSwitcherState = .Loading
            fetchRecommendations()
        }
    }
}