import UIKit
import RxSwift

class UserInfoViewController: UIViewController, UserInfoViewDelegate {

    private let initialUser: User
    
    private let userManager: UserManager
    private let disposeBag = DisposeBag()
    
    private var castView: UserInfoView { return view as! UserInfoView }
    
    let resolver: DiResolver
    
    init(resolver: DiResolver, initialUser: User) {
        self.resolver = resolver
        self.initialUser = initialUser
        userManager = resolver.resolve(UserManager.self)
        
        super.init(nibName: nil, bundle: nil)
        
        userManager.userObservable.subscribeNext(updateUserInfo).addDisposableTo(disposeBag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UserInfoView(user: initialUser)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        castView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
     
        logAnalyticsShowScreen(.UserData)
    }
    
    func updateUserInfo(user: User?) {
        logInfo("updateUserInfo user: \(user)")
        
        guard let user = user else {
            logInfo("user not logged")
            sendNavigationEvent(SimpleNavigationEvent(type: .Back))
            return
        }
        castView.updateData(user: user)
    }
    
    func userInfoViewDidTapDescription(view: UserInfoView) {
        logInfo("userInfoViewDidTapDescription")
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.showroom.pl/c/data")!)
    }
}