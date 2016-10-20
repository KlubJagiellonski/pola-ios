import Foundation
import UIKit
import WebKit

protocol WebContentViewDelegate: ViewSwitcherDelegate, WKNavigationDelegate { }

final class WebContentView: ViewSwitcher {
    private let webView = WKWebView(frame: CGRectZero)
    
    weak var delegate: WebContentViewDelegate? {
        didSet {
            switcherDelegate = delegate
            webView.navigationDelegate = delegate
        }
    }
    
    init() {
        super.init(successView: webView)
        
        backgroundColor = UIColor(named: .White)
        switcherDataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showWebContent(htmlString htmlString: String) {
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}

extension WebContentView: ViewSwitcherDataSource {
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: nil)
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return nil
    }
}
