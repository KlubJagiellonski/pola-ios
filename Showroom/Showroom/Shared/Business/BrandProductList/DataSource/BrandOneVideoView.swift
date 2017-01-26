import Foundation
import UIKit

final class BrandOneVideoView: UIView {
    weak var headerCell: BrandHeaderCell?
    var imageTag: Int {
        return "BrandOneVideoView".hashValue
    }
    
    private let topSeparatorView = UIView()
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        
        topSeparatorView.backgroundColor = UIColor(named: .White)
        
        imageView.tag = imageTag
        imageView.backgroundColor = UIColor(named: .White)
        imageView.layer.borderColor = UIColor(named: .White).CGColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        imageView.userInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImage)))
        
        titleLabel.font = UIFont(fontType: .Normal)
        titleLabel.numberOfLines = 5
        
        addSubview(topSeparatorView)
        addSubview(imageView)
        addSubview(titleLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with data: BrandVideo) {
        let imageHeight = bounds.height - Dimensions.boldSeparatorThickness - 2 * Dimensions.defaultMargin
        imageView.loadImageFromUrl(data.imageUrl, height: imageHeight)
        
        titleLabel.text = data.title
    }
    
    @objc private func didTapImage() {
        headerCell?.didTapVideo(atIndex: 0)
    }
    
    private func configureCustomConstraints() {
        topSeparatorView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.boldSeparatorThickness)
        }
        
        imageView.snp_makeConstraints { make in
            make.top.equalTo(topSeparatorView.snp_bottom).offset(Dimensions.defaultMargin)
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.leading.equalToSuperview().offset(Dimensions.defaultMargin)
            make.width.equalTo(imageView.snp_height).multipliedBy(Dimensions.videoImageRatio)
        }
        
        titleLabel.snp_makeConstraints { make in
            make.bottom.equalToSuperview().offset(-Dimensions.defaultMargin)
            make.leading.equalTo(imageView.snp_trailing).offset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().offset(-Dimensions.defaultMargin)
        }
    }
}


