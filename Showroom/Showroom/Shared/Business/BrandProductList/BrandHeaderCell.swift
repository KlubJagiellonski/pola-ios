import Foundation
import UIKit

final class BrandHeaderCell: UIControl {
    static let descriptionFont = UIFont(fontType: .Normal)
    
    private let imageView = UIImageView()
    private let blurredImageView = UIImageView()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
    private let descriptionTextView = UITextView()
    private let arrowImageView = UIImageView(image: UIImage(asset: .Ic_chevron_right))
    private let bottomSeparator = UIView()
    
    private var imageUrlToLoadOnLayoutPass: String?
    var imageWidth: Int {
        return UIImageView.scaledImageSize(imageView.bounds.width)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BrandHeaderCell.didTapView)))
        
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        imageView.backgroundColor = UIColor(named: .Gray)
        
        blurredImageView.contentMode = .ScaleAspectFill
        blurredImageView.layer.masksToBounds = true

        descriptionTextView.applyMarkdownStyle(maxNumberOfLines: 3)
        
        bottomSeparator.backgroundColor = UIColor(named: .Separator)
        
        addSubview(blurredImageView)
        addSubview(blurEffectView)
        addSubview(imageView)
        addSubview(descriptionTextView)
        addSubview(arrowImageView)
        addSubview(bottomSeparator)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let imageUrl = imageUrlToLoadOnLayoutPass where bounds.width > 0 && bounds.height > 0 {
            loadImage(forUrl: imageUrl)
            imageUrlToLoadOnLayoutPass = nil
        }
    }
    
    func updateData(withImageUrl imageUrl: String, description: NSAttributedString) {
        if bounds.width > 0 && bounds.height > 0 {
            loadImage(forUrl: imageUrl)
        } else {
            imageUrlToLoadOnLayoutPass = imageUrl
        }
        
        descriptionTextView.attributedText = description
    }
    
    func didTapView() {
        sendActionsForControlEvents(.TouchUpInside)
    }
    
    private func loadImage(forUrl url: String) {
        imageView.loadImageFromUrl(url, width: imageView.bounds.width) { [weak self](image: UIImage) in
            guard let `self` = self else { return }
            
            UIView.transitionWithView(self.blurredImageView, duration: 0.2, options: .TransitionCrossDissolve, animations: {
                self.blurredImageView.image = image
                }, completion: nil)
        }
    }
    
    private func configureCustomConstraints() {
        imageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(imageView.snp_height).multipliedBy(0.7433)
        }
        
        blurredImageView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurEffectView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        descriptionTextView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(imageView.snp_trailing).offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-42)
        }
        
        arrowImageView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-17)
        }
        
        bottomSeparator.snp_makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(Dimensions.defaultSeparatorThickness)
        }
    }
}