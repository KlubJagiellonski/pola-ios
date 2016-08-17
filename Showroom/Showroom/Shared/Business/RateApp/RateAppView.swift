import Foundation
import UIKit

protocol RateAppViewDelegate: class {
    func rateAppDidTapRate(view: RateAppView)
    func rateAppDidTapDecline(view: RateAppView)
    func rateAppDidTapRemindLater(view: RateAppView)
}

final class RateAppView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let rateButton = UIButton()
    private let bottomButtonsContentView = UIView()
    private let declineButton = UIButton()
    private let remindLaterButton = UIButton()
    
    weak var delegate: RateAppViewDelegate?
    
    init(withDescription description: String) {
        super.init(frame: CGRectZero)
        
        backgroundColor = UIColor(named: .White)
        
        titleLabel.text = tr(.RateAppTitle)
        titleLabel.font = UIFont(fontType: .Bold)
        
        descriptionLabel.text = description
        descriptionLabel.font = UIFont(fontType: .Description)
        descriptionLabel.numberOfLines = 0
        
        rateButton.applyBlueStyle()
        rateButton.title = tr(.RateAppRate)
        rateButton.addTarget(self, action: #selector(RateAppView.didTapRate), forControlEvents: .TouchUpInside)
        
        declineButton.applyPlainStyle()
        declineButton.title = tr(.RateAppDecline)
        declineButton.addTarget(self, action: #selector(RateAppView.didTapDecline), forControlEvents: .TouchUpInside)
        
        remindLaterButton.applyPlainStyle()
        remindLaterButton.title = tr(.RateAppOtherTime)
        remindLaterButton.addTarget(self, action: #selector(RateAppView.didTapRemindLater), forControlEvents: .TouchUpInside)
        
        bottomButtonsContentView.addSubview(declineButton)
        bottomButtonsContentView.addSubview(remindLaterButton)
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(rateButton)
        addSubview(bottomButtonsContentView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didTapRate() {
        delegate?.rateAppDidTapRate(self)
    }
    
    func didTapDecline() {
        delegate?.rateAppDidTapDecline(self)
    }
    
    func didTapRemindLater() {
        delegate?.rateAppDidTapRemindLater(self)
    }
    
    private func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom).offset(27)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
        
        var superview: UIView = self
        
        rateButton.snp_makeConstraints { make in
            make.top.equalTo(superview.snp_centerY)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.height.equalTo(Dimensions.bigButtonHeight)
        }
        
        bottomButtonsContentView.snp_makeConstraints { make in
            make.top.equalTo(rateButton.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        superview = bottomButtonsContentView
        
        declineButton.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalTo(superview.snp_centerX)
        }
        
        remindLaterButton.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(superview.snp_centerX)
            make.trailing.equalToSuperview()
        }
    }
}
