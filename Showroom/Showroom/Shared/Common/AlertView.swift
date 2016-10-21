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
    private var imageHeight: CGFloat {
        switch UIDevice.currentDevice().screenType {
        case .iPhone4:
            return 180
        default:
            return AlertView.defaultWidth - (2 * Dimensions.defaultMargin)
        }
    }
    
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let questionLabel = UILabel()
    
    private var imageViewSwitcher: ViewSwitcher?
    private var imageView: UIImageView? {
        guard let viewSwitcher = imageViewSwitcher else { return nil }
        return viewSwitcher.successView as? UIImageView
    }
    
    private let acceptButton = UIButton()
    private let declineButton = UIButton()
    private let remindButton = UIButton()
    
    private let imageUrl: String?
    
    weak var delegate: AlertViewDelegate?
    
    init(title: String, description: String, question: String? = nil, acceptButtonTitle: String?, imageUrl: String? = nil) {
        self.imageUrl = imageUrl
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
        
        if imageUrl != nil {
            let imageView = UIImageView()
            imageView.userInteractionEnabled = true
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AlertView.didTapImage)))
            let viewSwitcher = ViewSwitcher(successView: imageView)
            viewSwitcher.switcherDelegate = self
            viewSwitcher.switcherDataSource = self
            addSubview(viewSwitcher)
            
            self.imageViewSwitcher = viewSwitcher
        }
        
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(questionLabel)
        addSubview(acceptButton)
        addSubview(declineButton)
        addSubview(remindButton)
        
        configureCustomConstraints()
        
        loadImage()
    }
    
    func loadImage() {
        guard let imageUrl = imageUrl, viewSwitcher = imageViewSwitcher, imageView = imageView else {
            logInfo("Unable to start loading image with imageUrl: \(self.imageUrl)")
            return
        }
        
        imageView.loadImageFromUrl(imageUrl, height: imageHeight,
            failure: { error in
                logInfo("failed to load image with error: \(error)")
                viewSwitcher.changeSwitcherState(.Error, animated: true)
            }, success: { image in
                imageView.image = image
                viewSwitcher.changeSwitcherState(.Success, animated: true)
        })
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
    
    @objc private func didTapImage() {
        logInfo("Tapped image")
        delegate?.alertViewDidTapAccept(self)
    }
    
    private func configureCustomConstraints() {
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview().offset(AlertView.verticalInnerMargin)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp_makeConstraints { make in
            let offset = (imageViewSwitcher == nil) ? Dimensions.defaultMargin * 2 : Dimensions.defaultMargin
            make.top.equalTo(titleLabel.snp_bottom).offset(offset)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        questionLabel.snp_makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp_bottom).offset(Dimensions.defaultMargin)
            make.left.equalToSuperview().inset(Dimensions.defaultMargin)
            make.right.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        if let viewSwitcher = imageViewSwitcher {
            viewSwitcher.snp_makeConstraints { make in
                make.top.equalTo(descriptionLabel.snp_bottom).offset(Dimensions.defaultMargin)
                make.centerX.equalToSuperview()
                make.height.equalTo(imageHeight)
                make.width.equalTo(imageHeight)
            }
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
        var height = AlertView.verticalInnerMargin + titleHeight + descriptioinHeight + Dimensions.defaultMargin + questionHeight + Dimensions.defaultMargin  + Dimensions.bigButtonHeight + AlertView.verticalInnerMargin + Dimensions.bigButtonHeight + AlertView.verticalInnerMargin
        if imageUrl != nil {
            height += imageHeight + Dimensions.defaultMargin
        } else {
            height += 2 * Dimensions.defaultMargin
        }
        return CGSizeMake(AlertView.defaultWidth, height)
    }
}

extension AlertView: ViewSwitcherDelegate, ViewSwitcherDataSource {
    func viewSwitcherDidTapRetry(view: ViewSwitcher) {
        imageViewSwitcher?.changeSwitcherState(.Loading, animated: true)
        loadImage()
    }
    
    func viewSwitcherWantsEmptyView(view: ViewSwitcher) -> UIView? {
        return nil
    }
    
    func viewSwitcherWantsErrorView(view: ViewSwitcher) -> UIView? {
        return ErrorView(errorText: tr(.CommonError), errorImage: nil)
    }
}