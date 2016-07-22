import UIKit
import WebKit

class SettingsWebViewController: UIViewController {
    
    var castView: SettingsWebView { return view as! SettingsWebView }
    
    private let url: String
    
    init(resolver: DiResolver, url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = SettingsWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        castView.loadRequest(urlString: url)
    }
}

extension SettingsWebViewController: SettingsWebViewDelegate {
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("viewSwitcherDidTapRetry")
        castView.loadRequest(urlString: url)
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        logInfo("webView didStartProvisionalNavigation")
        castView.switcherState = .Loading
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        logInfo("webViewDidFinishNavigation")
        castView.switcherState = .Success
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        logInfo("webView didFailProvisionalNavigation error \(error.localizedDescription)")
        castView.switcherState = .Error
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        logInfo("webView didFailNavigation")
        castView.switcherState = .Error
    }
}