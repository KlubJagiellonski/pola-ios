import UIKit
import WebKit

final class TabWebViewController: UIViewController {
    private let url: String
    private var webView: WKWebView! {
        view as? WKWebView
    }

    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
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
    }
}
