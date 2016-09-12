import UIKit

class ProductListEmptyView: UIView {
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let imageView = UIImageView(image: UIImage(asset: .Img_wieszak))
    private let descriptionLabel = UILabel()
    
    var descriptionText: String? {
        set { descriptionLabel.text = newValue }
        get { return descriptionLabel.text }
    }
    
    init() {
        super.init(frame: CGRectZero)
        
        titleLabel.font = UIFont(fontType: .Bold)
        titleLabel.textColor = UIColor(named: .Black)
        titleLabel.text = tr(.CommonEmptyResultTitle)
        
        descriptionLabel.font = UIFont(fontType: .Description)
        descriptionLabel.textColor = UIColor(named: .Black)
        descriptionLabel.textAlignment = .Center
        descriptionLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(imageView)
        contentView.addSubview(descriptionLabel)
        
        addSubview(contentView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCustomConstraints() {
        contentView.snp_makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Dimensions.defaultMargin)
            make.trailing.equalToSuperview().inset(Dimensions.defaultMargin)
        }
        
        titleLabel.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp_makeConstraints { make in
            make.top.equalTo(titleLabel.snp_bottom).offset(48)
            make.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp_makeConstraints { make in
            make.top.equalTo(imageView.snp_bottom).offset(47)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
