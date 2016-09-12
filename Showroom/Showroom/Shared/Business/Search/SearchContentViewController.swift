import Foundation
import UIKit

enum SearchContentType {
    case Normal, Tree, BoldTree
}

class SearchContentViewController: UIViewController, SearchContentViewDelegate {
    private let mainSearchItem: SearchItem
    private let type: SearchContentType
    private var castView: SearchContentView { return view as! SearchContentView }
    
    init(mainSearchItem: SearchItem, type: SearchContentType) {
        self.mainSearchItem = mainSearchItem
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SearchContentView(with: mainSearchItem, contentType: type)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        castView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        castView.deselectRowsIfNeeded()
    }
    
    //MARK:- SearchContentViewDelegate
    
    func searchContent(view: SearchContentView, didSelectSearchItem searchItem: SearchItem) {
        logInfo("Did tap search item \(searchItem)")
        sendNavigationEvent(ShowSearchItemEvent(searchItem: searchItem, isMainItem: searchItem == mainSearchItem))
    }
}
