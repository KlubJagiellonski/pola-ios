import Foundation
import UIKit

final class BrandHeaderCell: UIView {
    private let topContentHeight: CGFloat = 84
    private let bottomContentHeight: CGFloat = 172
    
    weak var productListView: BrandProductListView?
    
    private let blurredImageView = UIImageView()
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight))
    private let topContentView = UIView()
    private let imageView = UIImageView()
    private let descriptionTextView = UITextView()
    private let arrowImageView = UIImageView(image: UIImage(asset: .Ic_chevron_right))
    private let bottomContentView = UIView()
    private weak var oneVideoView: BrandOneVideoView?
    private weak var multiVideoView: BrandMultiVideoView?
    
    private var imageUrlToLoadOnLayoutPass: String?
    var imageWidth: Int {
        return UIImageView.scaledImageSize(imageView.bounds.width)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        topContentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(BrandHeaderCell.didTapTopContentView)))
        
        blurredImageView.contentMode = .ScaleAspectFill
        blurredImageView.layer.masksToBounds = true
        
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        imageView.backgroundColor = UIColor(named: .Gray)

        descriptionTextView.applyMarkdownStyle(maxNumberOfLines: 3)
        
        addSubview(blurredImageView)
        addSubview(blurEffectView)
        addSubview(topContentView)
        topContentView.addSubview(imageView)
        topContentView.addSubview(descriptionTextView)
        topContentView.addSubview(arrowImageView)
        addSubview(bottomContentView)
        
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
    
    func updateData(with brand: BrandDetails, description: NSAttributedString) {
        if bounds.width > 0 && bounds.height > 0 {
            loadImage(forUrl: brand.imageUrl)
        } else {
            imageUrlToLoadOnLayoutPass = brand.imageUrl
        }
        
        descriptionTextView.attributedText = description
        
        bottomContentView.subviews.forEach { $0.removeFromSuperview() }
        
        if brand.videos.count == 1 {
            addOneVideoView(with: brand.videos[0])
        } else if brand.videos.count > 1 {
            addMultiVideoView(with: brand.videos)
        }
    }
    
    func videoImageTag(forIndex index: Int) -> Int? {
        if let oneVideoView = oneVideoView {
            return oneVideoView.imageTag
        } else if let multiVideoView = multiVideoView {
            return multiVideoView.imageTag(forIndex: index)
        } else {
            return nil
        }
    }
    
    func didTapTopContentView() {
        productListView?.didTapBrandInfo()
    }
    
    func didTapVideo(atIndex index: Int) {
        productListView?.didTapVideo(atIndex: index)
    }
    
    private func loadImage(forUrl url: String) {
        imageView.loadImageFromUrl(url, width: imageView.bounds.width) { [weak self](image: UIImage) in
            guard let `self` = self else { return }
            
            UIView.transitionWithView(self.blurredImageView, duration: 0.2, options: .TransitionCrossDissolve, animations: {
                self.blurredImageView.image = image
                }, completion: nil)
        }
    }
    
    private func addOneVideoView(with video: BrandVideo) {
        let view = BrandOneVideoView(frame: CGRect(x: 0, y: 0, width: 0, height: bottomContentHeight))
        view.headerCell = self
        bottomContentView.addSubview(view)
        view.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.update(with: video)
        oneVideoView = view
    }
    
    private func addMultiVideoView(with videos: [BrandVideo]) {
        let view = BrandMultiVideoView(frame: CGRect(x: 0, y: 0, width: 0, height: bottomContentHeight))
        view.headerCell = self
        bottomContentView.addSubview(view)
        view.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        view.update(with: videos)
        multiVideoView = view
    }
    
    private func configureCustomConstraints() {
        blurredImageView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurEffectView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        topContentView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(topContentHeight)
        }
        
        imageView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(imageView.snp_height).multipliedBy(0.7433)
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
        
        bottomContentView.snp_makeConstraints { make in
            make.top.equalTo(topContentView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    override func intrinsicContentSize() -> CGSize {
        let bottomContentContainsSubviews = !bottomContentView.subviews.isEmpty
        return CGSizeMake(UIViewNoIntrinsicMetric, bottomContentContainsSubviews ? topContentHeight + bottomContentHeight : topContentHeight)
    }
}
