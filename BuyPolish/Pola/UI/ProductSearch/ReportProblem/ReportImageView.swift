import UIKit

final class ReportImageView: UIView {
    
    private let imageView = UIImageView()
    private let dimImageView = UIImageView()
    let deleteButton = UIButton(type: .custom)
        
    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
                
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        addSubview(imageView)
        
        dimImageView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        addSubview(dimImageView)
        
        deleteButton.setImage(R.image.deleteIcon(), for: .normal)
        deleteButton.sizeToFit()
        addSubview(deleteButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageFrame = CGRect(origin: .zero, size: bounds.size)
        imageView.frame = imageFrame
        dimImageView.frame = imageFrame
        
        let removeButtonMargin = CGFloat(6.0)
        let deleteSize = deleteButton.frame.size
        let deleteButtonOrigin = CGPoint(
            x: imageFrame.maxX - removeButtonMargin - deleteSize.width,
            y: imageFrame.minY + removeButtonMargin
        )
        deleteButton.frame = CGRect(origin: deleteButtonOrigin, size: deleteSize)
    }
    
    private func setAlpha(for views: [UIView], alpha: CGFloat) {
        views.forEach { $0.alpha = alpha }
    }
}
