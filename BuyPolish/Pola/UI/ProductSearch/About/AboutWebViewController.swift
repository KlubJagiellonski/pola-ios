import UIKit
import WebKit

final class AboutWebViewController: UIViewController {
    private let url: String
    private var webView: WKWebView! {
        view as? WKWebView
    }

    init(url: String, title: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = WKWebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: url) else {
            return
        }
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = self
    }
}

extension AboutWebViewController: WKNavigationDelegate {
    func webView(_: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard navigationAction.navigationType != .other else {
            decisionHandler(.allow)
            return
        }
        decisionHandler(.cancel)
        if let url = navigationAction.request.url {
            UIApplication.shared.open(url)
        }
    }
}
