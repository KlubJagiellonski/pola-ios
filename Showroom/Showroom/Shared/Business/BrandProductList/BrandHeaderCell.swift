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
    
    var imageWidth: CGFloat? {
        return imageView.image?.size.width
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        alpha = 1
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
    
    func updateData(withImageUrl imageUrl: String, description: NSAttributedString) {
        imageView.loadImageFromUrl(imageUrl, width: imageView.bounds.width) { [weak self] (image: UIImage) in
            guard let `self` = self else { return }
            
            UIView.transitionWithView(self.blurredImageView, duration: 0.2, options: .TransitionCrossDissolve, animations: {
                self.blurredImageView.image = image.resizeAndCrop(toSize: self.bounds.size)
                }, completion: { success in
            })
            
            UIView.transitionWithView(self.imageView, duration: 0.1, options: .TransitionCrossDissolve, animations: {
                self.imageView.image = image
            }, completion: nil)
        }
        
        descriptionTextView.attributedText = description
    }
    
    func didTapView() {
        sendActionsForControlEvents(.TouchUpInside)
    }
    
    private func configureCustomConstraints() {
        imageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(imageView.snp_height).multipliedBy(Dimensions.defaultBrandImageRatio)
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