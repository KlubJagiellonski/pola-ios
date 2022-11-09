import UIKit
import WebKit

final class WebViewController: UIViewController {
    private let url: String
    private var webView: WebView! {
        view as? WebView
    }

    init(url: String, title: String? = nil) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = WebView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: url) else {
            return
        }

        webView.webView.load(URLRequest(url: url))
        webView.webView.navigationDelegate = self
    }
}

extension WebViewController: WKNavigationDelegate {
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
