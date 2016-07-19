import Foundation
import UIKit

enum SearchContentType {
    case Normal, Bold
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
        
        castView.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        castView.deselectRowsIfNeeded()
    }
    
    //MARK:- SearchContentViewDelegate
    
    func searchContentDidSelectMainSearchItem(view: SearchContentView) {
        sendNavigationEvent(ShowSearchItemEvent(searchItem: mainSearchItem, isMainItem: true))
    }
    
    func searchContent(view: SearchContentView, didSelectSearchItemAtIndex index: Int) {
        sendNavigationEvent(ShowSearchItemEvent(searchItem: mainSearchItem.branches![index], isMainItem: false))
    }
}
