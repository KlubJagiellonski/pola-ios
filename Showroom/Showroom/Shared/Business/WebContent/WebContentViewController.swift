import Foundation
import UIKit
import WebKit

final class WebContentViewController: UIViewController, WebContentViewDelegate {
    private var url: NSURL
    private var castView: WebContentView { return view as! WebContentView }
    
    init(url: NSURL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = WebContentView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        
        loadWebPage()
    }
    
    func updateData(with url: NSURL) {
        self.url = url
        castView.changeSwitcherState(.Loading)
        loadWebPage()
    }
    
    private func loadWebPage() {
        let request = NSURLRequest(URL: url)
        castView.loadWebPage(with: request)
    }
    
    // MARK:- WebContentViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("viewSwitcherDidTapRetry")
        castView.changeSwitcherState(.Loading)
        loadWebPage()
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
        
        guard url != webView.URL else {
            return decisionHandler(.Allow)
        }
        
        let app = UIApplication.sharedApplication()
        if navigationAction.targetFrame?.mainFrame ?? true {
            switch url.scheme {
            case "tel", "mailto":
                logInfo("Opening external url \(url)")
                if app.canOpenURL(url) {
                    app.openURL(url)
                }
                decisionHandler(.Cancel)
                return
            case "https":
                logInfo("Opening https link: \(url)")
                let event = ShowItemForLinkEvent(link: url.absoluteString, title: nil, productDetailsFromType: .HomeContentPromo)
                sendNavigationEvent(event)
                decisionHandler(.Cancel)
                return
            default: break
            }
        }
        
        decisionHandler(.Allow)
    }
    
}
