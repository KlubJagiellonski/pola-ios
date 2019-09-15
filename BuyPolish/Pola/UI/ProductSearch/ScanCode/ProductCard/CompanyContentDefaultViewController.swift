import UIKit

class CompanyContentDefaultViewController: UIViewController {
    let result: BPScanResult
    
    init(result: BPScanResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = CompanyContentDefaultView()
    }
    
    override func viewDidLoad() {
        let companyView = view as! CompanyContentDefaultView
        
        companyView.friendButton.addTarget(self, action: #selector(friendTapped), for: .touchUpInside)
        
        companyView.capitalProgressView.progress = result.plCapital
        companyView.notGlobalCheckRow.checked = result.plNotGlobEnt?.boolValue
        companyView.workersCheckRow.checked = result.plWorkers?.boolValue
        companyView.registeredCheckRow.checked = result.plRegistered?.boolValue
        companyView.rndCheckRow.checked = result.plRnD?.boolValue
        companyView.descriptionLabel.text = result.descr
        companyView.friendButton.isHidden = !result.isFriend
        
        switch result.cardType {
            
        case CardTypeGrey:
            companyView.capitalProgressView.setFill(Theme.strongBackgroundColor)
            companyView.capitalProgressView.setPercentColor(Theme.clearColor)
            
        case CardTypeWhite:
            companyView.capitalProgressView.setFill(Theme.lightBackgroundColor)
            companyView.capitalProgressView.setPercentColor(Theme.defaultTextColor)
            
        default:
            break
        }
    }
    
    @objc
    func friendTapped() {
        let webViewController = BPAboutWebViewController(url: "https://www.pola-app.pl/m/friends",
                                                         title: R.string.localizable.polaSFriends())
        let closeButtonItem =
            UIBarButtonItem(image: R.image.closeIcon(), style: .plain, target: self, action: #selector(closeWebViewTapped))
        closeButtonItem.accessibilityLabel = R.string.localizable.accessibilityClose()
        webViewController.navigationItem.rightBarButtonItem = closeButtonItem
        let navigationController = UINavigationController(rootViewController: webViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc
    func closeWebViewTapped() {
        dismiss(animated: true, completion: nil)
    }
    
}
