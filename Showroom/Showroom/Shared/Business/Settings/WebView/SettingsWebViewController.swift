import UIKit
import WebKit
import RxSwift

class SettingsWebViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    var model: SettingsWebViewModel
    var castView: SettingsWebView { return view as! SettingsWebView }
    
    init(model: SettingsWebViewModel) {
        self.model = model
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
        fetchWebContent()
    }
    
    func fetchWebContent() {
        logInfo("Fetching web content")
        castView.changeSwitcherState(.Loading)
        
        model.fetchWebContent().subscribe { [weak self] (fetchResult: Event<WebContentResult>) in
            guard let `self` = self else { return }
            switch fetchResult {
            case .Error(let error):
                logInfo("Error during fetching settings web content, error: \(error)")
                self.castView.changeSwitcherState(.Error)
            case .Next(let result):
                logInfo("Fetched settings web content: \(result)")
                self.castView.showWebContent(htmlString: result)
            default: break
            }
        }.addDisposableTo(disposeBag)
    }
}

extension SettingsWebViewController: SettingsWebViewDelegate {
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("viewSwitcherDidTapRetry")
        fetchWebContent()
    }
    
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        logInfo("webView didStartProvisionalNavigation")
        castView.changeSwitcherState(.Loading)
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        logInfo("webViewDidFinishNavigation")
        castView.changeSwitcherState(.Success)
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        logInfo("webView didFailProvisionalNavigation error \(error.localizedDescription)")
        castView.changeSwitcherState(.Error)
    }
    
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        logInfo("webView didFailNavigation")
        castView.changeSwitcherState(.Error)
    }

    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.URL else {
            return decisionHandler(.Cancel)
        }
        
        let app = UIApplication.sharedApplication()
        
        if navigationAction.targetFrame == nil || ["tel", "mailto", "https", "http"].contains(url.scheme) {
            logInfo("Opening external url \(url)")
            if app.canOpenURL(url) {
                app.openURL(url)
            }
            decisionHandler(.Cancel)
            return
        }
        
        decisionHandler(.Allow)
    }
}