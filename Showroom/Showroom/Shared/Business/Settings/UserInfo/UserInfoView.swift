import UIKit

protocol UserInfoViewDelegate: class {
    func userInfoViewDidTapDescription(view: UserInfoView)
}

class UserInfoView: UIView, UserInfoContainerViewDelegate {
    
    private let scrollView = UIScrollView()
    private let containerView = UserInfoContainerView()
    
    weak var delegate: UserInfoViewDelegate?
    
    init(user: User) {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        scrollView.bounces = true
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        
        containerView.delegate = self
        scrollView.addSubview(containerView)
        
        updateData(user: user)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateData(user user: User) {
        containerView.update(user: user)
    }
    
    func userInfoContainerViewDidTapDescription(view: UserInfoContainerView) {
        delegate?.userInfoViewDidTapDescription(self)
    }
    
    func configureCustomConstraints() {
        scrollView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.snp_makeConstraints { make in
            make.edges.equalTo(scrollView.snp_edges)
            make.width.equalTo(self)
        }

    }
}