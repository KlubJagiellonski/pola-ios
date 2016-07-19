import UIKit

class SettingsWebViewController: UIViewController {
    let url: String
    
    var castView: UIWebView { return view as! UIWebView }
    
    init(resolver: DiResolver, url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nsurl = NSURL(string: url)!
        castView.loadRequest(NSURLRequest(URL: nsurl))
    }
}