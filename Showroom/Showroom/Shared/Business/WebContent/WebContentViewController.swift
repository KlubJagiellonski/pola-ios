import Foundation
import UIKit
import WebKit
import RxSwift

final class WebContentViewController: UIViewController, WebContentViewDelegate {
    private let model: WebContentModel
    private var castView: WebContentView { return view as! WebContentView }
    
    private var disposeBag = DisposeBag()
    
    init(resolver: DiResolver, entry: WebContentEntry) {
        model = resolver.resolve(WebContentModel.self, argument: entry)
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logAnalyticsShowScreen(AnalyticsScreenId.WebContent, refferenceUrl: model.entry.link)
    }
    
    func updateData(with entry: WebContentEntry) {
        logAnalyticsShowScreen(AnalyticsScreenId.WebContent, refferenceUrl: entry.link)
        disposeBag = DisposeBag()
        model.update(with: entry)
        castView.changeSwitcherState(.Loading)
        loadWebPage()
    }
    
    private func loadWebPage() {
        model.fetchWebContent()
            .subscribe { [unowned self](event: Event<WebContent>) in
                switch event {
                case .Next(let webContent):
                    logInfo("on next, webContent: \(webContent)")
                    self.castView.changeSwitcherState(.Success)
                    self.castView.showWebContent(htmlString: webContent.content)
                    self.title = webContent.title
                    
                case .Error(let error):
                    logInfo("on error: \(error)")
                    self.castView.changeSwitcherState(.Error)
                    
                default: break
                }
        }.addDisposableTo(disposeBag)
    }
    
    // MARK:- WebContentViewDelegate
    
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        logInfo("viewSwitcherDidTapRetry")
        castView.changeSwitcherState(.Loading)
        loadWebPage()
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.URL else {
            return decisionHandler(.Cancel)
        }
        
        guard url != webView.URL else {
            return decisionHandler(.Allow)
        }
        
        let app = UIApplication.sharedApplication()
        if let scheme = url.scheme where navigationAction.targetFrame?.mainFrame ?? true {
            switch scheme {
            case "tel", "mailto":
                logInfo("Opening external url \(url)")
                if app.canOpenURL(url) {
                    app.openURL(url)
                }
                decisionHandler(.Cancel)
                return
            case "https":
                logInfo("Opening https link: \(url)")
                let urlString = url.absoluteString ?? url.relativeString
                let event = ShowItemForLinkEvent(link: urlString, title: nil, productDetailsFromType: .HomeContentPromo, transitionImageTag: nil)
                sendNavigationEvent(event)
                decisionHandler(.Cancel)
                return
            default: break
            }
        }
        
        decisionHandler(.Allow)
    }
    
}
