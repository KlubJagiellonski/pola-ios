import UIKit
import WebKit

protocol SettingsWebViewDelegate: ViewSwitcherDelegate, WKNavigationDelegate { }

class SettingsWebView: ViewSwitcher {
    private let webView = WKWebView(frame: CGRectZero)
    
    weak var delegate: SettingsWebViewDelegate? {
        didSet {
            switcherDelegate = delegate
            webView.navigationDelegate = delegate
        }
    }
    
    init() {
        super.init(successView: webView, initialState: .Success)
        
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

extension SettingsWebView: ViewSwitcherDataSource {
    
    func viewSwitcherWantsErrorInfo(view: ViewSwitcher) -> (ErrorText, ErrorImage?) {
        return (tr(.CommonError), nil)
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return nil
    }
}