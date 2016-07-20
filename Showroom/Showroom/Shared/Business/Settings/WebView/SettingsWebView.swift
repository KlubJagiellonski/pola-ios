import UIKit

protocol SettingsWebViewDelegate: ViewSwitcherDelegate, UIWebViewDelegate { }

class SettingsWebView: ViewSwitcher {
    private let webView = UIWebView()
    
    weak var delegate: SettingsWebViewDelegate? {
        didSet {
            switcherDelegate = delegate
            webView.delegate = delegate
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
    
    func loadRequest(urlString urlString: String) {
        let url = NSURL(string: urlString)!
        webView.loadRequest(NSURLRequest(URL: url))
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