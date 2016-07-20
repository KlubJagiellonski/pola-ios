import UIKit

class SettingsWebViewController: UIViewController {
    
    var castView: SettingsWebView { return view as! SettingsWebView }
    
    let url: String
    private var webViewLoaded = false
    
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
    
    func webViewDidStartLoad(webView: UIWebView) {
        logInfo("webViewDidStartLoad")
        guard !webViewLoaded else { return }
        castView.switcherState = .Loading
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        logInfo("webViewDidFinishLoad")
        guard !webViewLoaded else { return }
        castView.switcherState = .Success
        webViewLoaded = true
    }
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        logInfo("webView didFailLoadWithError")
        guard !webViewLoaded else { return }
        castView.switcherState = .Error
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let shouldLoad = request.URL?.absoluteString == url
        logInfo("webView shouldStartLoadWithRequest: \(request) -> shouldLoad: \(shouldLoad)")
        return shouldLoad
    }
}