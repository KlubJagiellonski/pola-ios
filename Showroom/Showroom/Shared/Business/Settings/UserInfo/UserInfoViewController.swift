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
        
        // TODO: remove after testing
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(UserInfoViewController.test), name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // TODO: remove after testing
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // TODO: remove after testing
    func test() {
        logInfo("user info did change test")
        let user: User? = User(id: 1234, name: "test", email: "test@test", userAddresses: [
            UserAddress(firstName: "test", lastName: "Kowalski", streetAndAppartmentNumbers: "Sikorskiego 12/30", postalCode: "15-888", city: "Białystok", country: "POLSKA", phone: "+48 501 123 456", description: "opis 1"),
            UserAddress(firstName: "test", lastName: "Kowalska", streetAndAppartmentNumbers: "Piękna 5/10", postalCode: "02-758", city: "Warszawa", country: "POLSKA", phone: "+48 788 123 456", description: "opis 2"),
            UserAddress(firstName: "test", lastName: "Kowalski", streetAndAppartmentNumbers: "Sikorskiego 12/30", postalCode: "15-888", city: "Białystok", country: "POLSKA", phone: "+48 501 123 456", description: "opis 1"),
            UserAddress(firstName: "test", lastName: "Kowalska", streetAndAppartmentNumbers: "Piękna 5/10", postalCode: "02-758", city: "Warszawa", country: "POLSKA", phone: "+48 788 123 456", description: "opis 2")
            ])
//        let user: User? = nil
        userManager.userObservable.onNext(user)
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