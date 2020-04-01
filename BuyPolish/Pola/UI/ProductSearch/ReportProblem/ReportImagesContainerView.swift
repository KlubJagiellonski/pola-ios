import UIKit

protocol ReportImagesContainerViewDelegate: class {
    func imagesContainerTapDeleteButton(at index: Int)
    func imagesContainerTapAddButton()
}

final class ReportImagesContainerView: UIView {
    
    private let maxImageViewsCount = 3
    private var imageViews = [ReportImageView]()
    private let animationDuration = TimeInterval(0.5)
    private let addImageButton = UIButton(type: .custom)
    private let imagePadding = CGFloat(6.0)
    private let imageMargin = CGFloat(4.0)
    
    weak var delegate: ReportImagesContainerViewDelegate?
    
    var images: [UIImage] {
        get {
            imageViews.compactMap({$0.image})
        }
        set {
            imageViews.forEach { view in
                view.removeFromSuperview()
            }
            imageViews = newValue
                .prefix(maxImageViewsCount)
                .map { createImageView(image: $0)}
            
            updateButtonTags()
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        clipsToBounds = true
        backgroundColor = Theme.clearColor
        
        addImageButton.addTarget(self, action: #selector(tapAdd), for: .touchUpInside)
        addImageButton.accessibilityLabel = R.string.localizable.accessibilityReportAddPhoto()
        addImageButton.backgroundColor = Theme.lightBackgroundColor
        addImageButton.setImage(R.image.addIcon(), for: .normal)
        addSubview(addImageButton)
        
        imageViews.enumerated().forEach { (index, view) in
            view.tag = index
            view.deleteButton.addTarget(self, action: #selector(tapDelete(sender:)), for: .touchUpInside)
            addSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func addImage(_ image: UIImage) {
        let imageView = createImageView(image: image)
        imageViews.append(imageView)
        updateButtonTags()
        
        imageView.alpha = 0.0
        UIImageView.animate(withDuration: animationDuration) {
            imageView.alpha = 1.0
            
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }

    }
    
    func removeImage(at index: Int) {
        let imageView = imageViews.remove(at: index)
        updateButtonTags()
        
        UIView.animate(withDuration: animationDuration, animations: {
            imageView.alpha = 0.0
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }) { _ in
            imageView.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageWidth = calculateImageWidth(viewWidth: bounds.width)
        
        var rect = CGRect(
            x: imagePadding,
            y: imagePadding,
            width: imageWidth,
            height: imageWidth
        )
        
        imageViews.forEach { imageView in
            imageView.frame = rect
            rect.origin.x += rect.width + imageMargin
        }
        
        addImageButton.frame = rect
        addImageButton.alpha = imageViews.count == maxImageViewsCount ? 0.0 : 1.0
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let imageWidth = calculateImageWidth(viewWidth: size.width)
        return CGSize(width: size.width, height: imageWidth + (2.0 * imagePadding))
    }
    
    private func calculateImageWidth(viewWidth: CGFloat) -> CGFloat {
        let paddings = 2 * imagePadding
        let margins = CGFloat(maxImageViewsCount - 1) * imageMargin
        let images = viewWidth - paddings - margins
        return (images / CGFloat(maxImageViewsCount)).rounded(.down)
    }
    
    
    @objc
    private func tapDelete(sender: UIButton) {
        delegate?.imagesContainerTapDeleteButton(at: sender.tag)
    }
    
    @objc
    private func tapAdd() {
        delegate?.imagesContainerTapAddButton()
    }
    
    private func updateButtonTags() {
        imageViews.enumerated().forEach { (i, view) in
            view.deleteButton.tag = i
        }
    }
    
    private func createImageView(image: UIImage) -> ReportImageView {
        let imageView = ReportImageView()
        imageView.image = image
        imageView.deleteButton.addTarget(self, action: #selector(tapDelete(sender:)), for: .touchUpInside)
        addSubview(imageView)
        return imageView
    }
}
