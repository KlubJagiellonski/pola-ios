import Foundation
import UIKit
import RxSwift

final class SearchViewController: UIViewController, SearchViewDelegate {
    private let disposeBag = DisposeBag()
    private let resolver: DiResolver
    private var castView: SearchView { return view as! SearchView }
    private let model: SearchModel
    private var indexedViewControllers: [Int: UIViewController] = [:]
    private var firstLayoutSubviewsPassed = false
    
    init(with resolver: DiResolver) {
        self.resolver = resolver
        self.model = resolver.resolve(SearchModel.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SearchView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.pageHandler = self
        castView.delegate = self
        
        fetchSearchItems()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(.Search)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        markHandoffUrlActivity(withPath: "/")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !firstLayoutSubviewsPassed {
            firstLayoutSubviewsPassed = true
            castView.extendedContentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: 0, right: 0)
        }
    }
    
    private func fetchSearchItems() {
        model.fetchSearchItems().subscribeNext { [weak self] (cacheResult: FetchCacheResult<SearchResult>) in
            guard let `self` = self else { return }
            switch cacheResult {
            case .Success(let result):
                self.removeAllViewControllers()
                self.castView.switcherState = .Success
                self.castView.updateData(with: result.rootItems)
            case .CacheError(let error):
                logError("Error while fetching cached search result \(error)")
                break
            case .NetworkError(let error):
                logInfo("Couldn't download search result \(error)")
                if self.model.searchResult == nil {
                    self.castView.switcherState = .Error
                }
                break
            }
        }.addDisposableTo(disposeBag)
    }
    
    //MARK:- SearchViewDelegate
    
    func search(view: SearchView, didTapSearchWithQuery query: String) {
        sendNavigationEvent(ShowProductSearchEvent(query: query))
    }
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        self.castView.switcherState = .Loading
        fetchSearchItems()
    }
}

extension SearchViewController: SearchPageHandler {
    func page(forIndex index: Int) -> UIView {
        let indexedViewController = indexedViewControllers[index]
        let viewController = indexedViewController ?? createViewController(forIndex: index)
        if indexedViewController == nil {
            addChildViewController(viewController)
            indexedViewControllers[index] = viewController
        }
        return viewController.view
    }
    
    func pageAdded(forIndex index: Int) {
        let newViewController = indexedViewControllers[index]!
        newViewController.didMoveToParentViewController(self)
    }
    
    private func createViewController(forIndex index: Int) -> UIViewController {
        guard let searchResult = model.searchResult else { fatalError("Cannot create viewcontroller when searchResult is nil") }
        return resolver.resolve(SearchContentNavigationController.self, argument: searchResult.rootItems[index])
    }
    
    private func removeAllViewControllers() {
        indexedViewControllers.forEach { (index, viewController) in
            viewController.willMoveToParentViewController(nil)
            viewController.view.removeFromSuperview()
            viewController.removeFromParentViewController()
        }
        indexedViewControllers.removeAll()
    }
}