import Foundation
import UIKit

final class BrandMultiVideoView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    private var brandVideos: [BrandVideo] = []
    weak var headerCell: BrandHeaderCell?
    
    private let topSeparatorView = UIView()
    private let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topSeparatorView.backgroundColor = UIColor(named: .White)
        
        let itemHeight: CGFloat = 140
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.registerClass(BrandVideoCell.self, forCellWithReuseIdentifier: String(BrandVideoCell))
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Horizontal
        flowLayout.itemSize = CGSizeMake(itemHeight * Dimensions.videoImageRatio, itemHeight)
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.sectionInset = UIEdgeInsets(top: Dimensions.defaultMargin, left: Dimensions.defaultMargin, bottom: Dimensions.defaultMargin, right: Dimensions.defaultMargin)
        
        addSubview(topSeparatorView)
        addSubview(collectionView)
        
        configureCustomConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with videos: [BrandVideo]) {
        brandVideos = videos
        collectionView.reloadData()
    }
    
    func imageTag(forIndex index: Int) -> Int {
        return "\(brandVideos[safe: index]?.id) \(index)".hashValue
    }
    
    private func configureCustomConstraints() {
        topSeparatorView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Dimensions.boldSeparatorThickness)
        }
        
        collectionView.snp_makeConstraints { make in
            make.top.equalTo(topSeparatorView.snp_bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK:- UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        headerCell?.didTapVideo(atIndex: indexPath.item)
    }
    
    // MARK:- UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandVideos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let video = brandVideos[indexPath.item]
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(BrandVideoCell), forIndexPath: indexPath) as! BrandVideoCell
        cell.imageTag = imageTag(forIndex: indexPath.item)
        cell.update(with: video)
        return cell
    }
}
