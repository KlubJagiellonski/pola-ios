import Foundation
import UIKit

protocol NotificationsAccessViewDelegate: class {
    func notificationsAccessViewDidTapAllow(view: NotificationsAccessView)
    func notificationsAccessViewDidTapDecline(view: NotificationsAccessView)
    func notificationsAccessViewDidTapRemindLater(view: NotificationsAccessView)
}

final class NotificationsAccessView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let questionLabel = UILabel()
    private let allowButton = UIButton()
    private let declineButton = UIButton()
    private let remindLaterButton = UIButton()
    
    weak var delegate: NotificationsAccessViewDelegate?
    
    init(withDescription description: String) {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        titleLabel.text = tr(L10n.PushNotificationTitle)
        titleLabel.font = UIFont(fontType: .Bold)
        
        descriptionLabel.text = description
        descriptionLabel.font = UIFont(fontType: .Description)
        descriptionLabel.numberOfLines = 0
        
        questionLabel.text = tr(L10n.PushNotificationQuestion)
        questionLabel.font = UIFont(fontType: .Description)
        
        allowButton.applyBlueStyle()
        allowButton.title = tr(L10n.PushNotificationAllow)
        allowButton.addTarget(self, action: #selector(NotificationsAccessView.didTapAllow), forControlEvents: .TouchUpInside)
        
        declineButton.applyPlainStyle()
        declineButton.title = tr(L10n.PushNotificationDecline)
        declineButton.addTarget(self, action: #selector(NotificationsAccessView.didTapDecline), forControlEvents: .TouchUpInside)
        
        remindLaterButton.applyPlainStyle()
        remindLaterButton.title = tr(L10n.PushNotificationRemindLater)
        remindLaterButton.addTarget(self, action: #selector(NotificationsAccessView.didTapRemindLater), forControlEvents: .TouchUpInside)
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(questionLabel)
        addSubview(allowButton)
        addSubview(declineButton)
        addSubview(remindLaterButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapAllow() {
        delegate?.notificationsAccessViewDidTapAllow(self)
    }
    
    @objc private func didTapDecline() {
        delegate?.notificationsAccessViewDidTapDecline(self)
    }
    
    @objc private func didTapRemindLater() {
        delegate?.notificationsAccessViewDidTapRemindLater(self)
    }
    
    private func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom).offset(Dimensions.defaultMargin * 2)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        questionLabel.snp_makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(Dimensions.defaultMargin)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        allowButton.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
        
        let superview = self
        
        declineButton.snp_makeConstraints { make in
            make.top.equalTo(allowButton.snp_bottom).offset(10)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalTo(superview.snp_centerX)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
        
        remindLaterButton.snp_makeConstraints { make in
            make.top.equalTo(allowButton.snp_bottom).offset(10)
            make.left.equalTo(superview.snp_centerX)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
    }
}
