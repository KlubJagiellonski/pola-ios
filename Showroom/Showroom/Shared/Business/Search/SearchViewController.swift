import Foundation
import UIKit

final class SearchViewController: UIViewController, SearchViewDelegate {
    private var castView: SearchView { return view as! SearchView }
    private var indexedViewControllers: [Int: UIViewController] = [:]
    private var firstLayoutSubviewsPassed = false
    
    init(resolver: DiResolver) {
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
        castView.updateData(with: ["ONA", "ON", "MARKI"])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if !firstLayoutSubviewsPassed {
            firstLayoutSubviewsPassed = true
            castView.extendedContentInset = UIEdgeInsets(top: topLayoutGuide.length, left: 0, bottom: bottomLayoutGuide.length, right: 0)
        }
    }
    
    //MARK:- SearchViewDelegate
    
    func search(view: SearchView, didTapSearchWithQuery query: String?) {
        //todo search
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
    
    func createViewController(forIndex index: Int) -> UIViewController {
        //todo use resolver in future
        return SearchContentViewController()
    }
}