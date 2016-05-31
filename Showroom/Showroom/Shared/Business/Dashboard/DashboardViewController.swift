import Foundation
import UIKit
import RxSwift

class DashboardViewController: UIViewController, DashboardViewDelegate {
    private let model: DashboardModel
    private var castView: DashboardView { return view as! DashboardView }
    
    private let disposeBag = DisposeBag()
    
    init(resolver: DiResolver) {
        self.model = resolver.resolve(DashboardModel.self)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = DashboardView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        castView.delegate = self
        
        model.fetchContentPromo()
            .subscribe(onNext: { [weak self] contentPromoResult in
                    self?.castView.changeContentPromos(contentPromoResult.contentPromos)
                }, onError: { error in
                    logError("Error while downloading content promo: \(error)")
                }).addDisposableTo(disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        castView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: bottomLayoutGuide.length, right: 0)
    }
}