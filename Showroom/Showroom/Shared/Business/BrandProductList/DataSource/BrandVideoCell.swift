import Foundation

extension BrandVideoTitleStyle {
    private func gradientColors() -> [CGColor] {
        switch self {
        case .Black:
            return [UIColor.whiteColor().colorWithAlphaComponent(0).CGColor, UIColor.whiteColor().CGColor]
        case .White:
            return [UIColor.blackColor().colorWithAlphaComponent(0).CGColor, UIColor.blackColor().CGColor]
        }
    }
    
    private func color() -> UIColor {
        switch self {
        case .Black:
            return UIColor.blackColor()
        default:
            return UIColor.whiteColor()
        }
    }
}

final class BrandVideoCell: UICollectionViewCell {
    var imageTag: Int {
        set { imageView.tag = newValue }
        get { return imageView.tag }
    }
    
    private let imageView = UIImageView()
    private let backgroundGradientLayer = CAGradientLayer()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(named: .White)
        
        imageView.backgroundColor = backgroundColor
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        
        titleLabel.font = UIFont(fontType: .Description)
        titleLabel.numberOfLines = 3
        
        contentView.addSubview(imageView)
        contentView.layer.addSublayer(backgroundGradientLayer)
        contentView.addSubview(titleLabel)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundGradientLayer.frame = CGRectInset(contentView.bounds, 1, 1)
    }
    
    func update(with video: BrandVideo) {
        imageView.loadImageFromUrl(video.imageUrl, width: bounds.width - 2)
        titleLabel.text = video.title
        titleLabel.textColor = video.color.color()
        backgroundGradientLayer.colors = video.color.gradientColors()
    }
    
    private func configureCustomConstraints() {
        imageView.snp_makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsetsMake(1, 1, 1, 1))
        }
        
        titleLabel.snp_makeConstraints { make in
            make.bottom.equalToSuperview().offset(-6)
            make.leading.equalToSuperview().offset(10)
            make.trailing.equalToSuperview().offset(-10)
        }
    }
}
