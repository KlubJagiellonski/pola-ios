import UIKit
import WebKit

final class WebView: UIView {
    let webView = WKWebView()

    init(ignoreSafeArea: Bool) {
        super.init(frame: .zero)
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false

        let webViewBottomAnchor = ignoreSafeArea ? bottomAnchor : safeAreaLayoutGuide.bottomAnchor
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: topAnchor),
            webView.bottomAnchor.constraint(equalTo: webViewBottomAnchor),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
