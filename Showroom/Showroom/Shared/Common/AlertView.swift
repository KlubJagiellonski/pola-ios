import Foundation
import UIKit

protocol AlertViewDelegate: class {
    func alertViewDidTapAccept(view: AlertView)
    func alertViewDidTapDecline(view: AlertView)
    func alertViewDidTapRemind(view: AlertView)
}

final class AlertView: UIView {
    private static let defaultWidth: CGFloat = 290.0
    private static let verticalInnerMargin: CGFloat = 10.0
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let questionLabel = UILabel()
    
    private let acceptButton = UIButton()
    private let declineButton = UIButton()
    private let remindButton = UIButton()
    
    weak var delegate: AlertViewDelegate?
    
    init(title: String, description: String, question: String? = nil, acceptButtonTitle: String?) {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        titleLabel.text = title
        titleLabel.font = UIFont(fontType: .Bold)
        titleLabel.numberOfLines = 1
        
        descriptionLabel.text = description
        descriptionLabel.textAlignment = .Center
        descriptionLabel.font = UIFont(fontType: .Description)
        descriptionLabel.numberOfLines = 0
        
        questionLabel.text = question
        questionLabel.textAlignment = .Center
        questionLabel.font = UIFont(fontType: .Description)
        questionLabel.numberOfLines = 1
        
        acceptButton.applyBlueStyle()
        acceptButton.title = acceptButtonTitle ?? tr(L10n.AlertViewAccept)
        acceptButton.addTarget(self, action: #selector(AlertView.didTapAccept), forControlEvents: .TouchUpInside)
        
        declineButton.applyPlainStyle()
        declineButton.title = tr(L10n.AlertViewDecline)
        declineButton.addTarget(self, action: #selector(AlertView.didTapDecline), forControlEvents: .TouchUpInside)
        
        remindButton.applyPlainStyle()
        remindButton.title = tr(L10n.AlertViewRemindLater)
        remindButton.addTarget(self, action: #selector(AlertView.didTapRemind), forControlEvents: .TouchUpInside)
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(questionLabel)
        addSubview(acceptButton)
        addSubview(declineButton)
        addSubview(remindButton)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapAccept() {
        logInfo("Tapped accept")
        delegate?.alertViewDidTapAccept(self)
    }
    
    @objc private func didTapDecline() {
        logInfo("Tapped decline")
        delegate?.alertViewDidTapDecline(self)
    }
    
    @objc private func didTapRemind() {
        logInfo("Tapped remind later")
        delegate?.alertViewDidTapRemind(self)
    }
    
    private func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(AlertView.verticalInnerMargin)
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
        
        acceptButton.snp_makeConstraints { make in
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
        
        let superview = self
        
        declineButton.snp_makeConstraints { make in
            make.top.equalTo(acceptButton.snp_bottom).offset(AlertView.verticalInnerMargin)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalTo(superview.snp_centerX)
            make.bottom.equalToSuperview().offset(-AlertView.verticalInnerMargin)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
        
        remindButton.snp_makeConstraints { make in
            make.top.equalTo(acceptButton.snp_bottom).offset(AlertView.verticalInnerMargin)
            make.left.equalTo(superview.snp_centerX)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().offset(-AlertView.verticalInnerMargin)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let constraintRect = CGSize(width: AlertView.defaultWidth - Dimensions.defaultMargin * 2, height: CGFloat.max)
        let titleHeight = titleLabel.sizeThatFits(constraintRect).height
        let descriptioinHeight = descriptionLabel.sizeThatFits(constraintRect).height
        let questionHeight = questionLabel.text == nil ? 0.0 : questionLabel.sizeThatFits(constraintRect).height
        let height = AlertView.verticalInnerMargin + titleHeight + Dimensions.defaultMargin * 2 + descriptioinHeight + Dimensions.defaultMargin + questionHeight + Dimensions.defaultMargin + Dimensions.bigButtonHeight + AlertView.verticalInnerMargin + Dimensions.bigButtonHeight + AlertView.verticalInnerMargin
        return CGSizeMake(AlertView.defaultWidth, height)
    }
}