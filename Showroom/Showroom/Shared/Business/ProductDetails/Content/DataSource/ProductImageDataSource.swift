import Foundation
import UIKit

enum ProductImageDataSourceState {
    case Default
    case FullScreen
}

protocol ProductImageCellInterface: class {
    var fullScreenMode: Bool { get set }
    var screenInset: UIEdgeInsets? { get set }
    var fullScreenInset: UIEdgeInsets? { get set }
    func didEndDisplaying()
}

final class ProductImageDataSource: NSObject, UICollectionViewDataSource, ProductImageCellDelegate, ProductImageVideoCellDelegate {
    private weak var collectionView: UICollectionView?
    
    private var imageUrls: [String] = []
    private var videos: [ProductDetailsVideo] = []
    private let assetsFactory: Int -> AVAsset
    var lowResImageUrl: String?
    var state: ProductImageDataSourceState = .Default {
        didSet {
            informVisibleCells { (cell: ProductImageCellInterface) in
                cell.fullScreenMode = state == .FullScreen
            }
        }
    }
    var highResImageVisible: Bool = true {
        didSet {
            informVisibleCells { (cell: ProductImageCell) in
                cell.imageVisible = highResImageVisible
            }
        }
    }
    var pageCount: Int {
        return imageUrls.count + videos.count
    }
    var fullScreenInset = UIEdgeInsets()
    var screenInset = UIEdgeInsets()
    weak var productPageView: ProductPageView?
    
    init(collectionView: UICollectionView, assetsFactory: Int -> AVAsset) {
        self.assetsFactory = assetsFactory
        super.init()
        
        self.collectionView = collectionView
        collectionView.registerClass(ProductImageCell.self, forCellWithReuseIdentifier: String(ProductImageCell))
        collectionView.registerClass(ProductImageVideoCell.self, forCellWithReuseIdentifier: String(ProductImageVideoCell))
    }
    
    func update(withImageUrls imageUrls: [String], videos: [ProductDetailsVideo]) {
        guard let collectionView = collectionView else { return }
        
        let oldImageUrls = self.imageUrls
        let oldVideos = self.videos
        self.videos = videos
        self.imageUrls = imageUrls
        
        guard oldImageUrls.count != 0 else {
            collectionView.reloadData()
            return
        }
        if let cell = collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: 0, inSection: 0)) as? ProductImageCell where oldImageUrls[0] != imageUrls[0] {
            cell.update(withImageUrl: imageUrls[0], lowResImageUrl: lowResImageUrl)
        }
        
        guard imageUrls.count > 1 || !videos.isEmpty else { return }
        
        var reloadIndexPaths: [NSIndexPath] = []
        var deleteIndexPaths: [NSIndexPath] = []
        var insertIndexPaths: [NSIndexPath] = []
        
        let oldCount = oldImageUrls.count + oldVideos.count
        let newCount = imageUrls.count + videos.count
        
        let maxCommonCount = min(oldCount, newCount)
        if maxCommonCount > 1 {
            for index in 1...(maxCommonCount - 1) {
                reloadIndexPaths.append(NSIndexPath(forItem: index, inSection: 0))
            }
        }
        
        if newCount > oldCount {
            for index in oldCount...(newCount - 1) {
                insertIndexPaths.append(NSIndexPath(forItem: index, inSection: 0))
            }
        } else if newCount < oldCount {
            for index in newCount...(oldCount - 1) {
                deleteIndexPaths.append(NSIndexPath(forItem: index, inSection: 0))
            }
        }
        
        if reloadIndexPaths.isEmpty && deleteIndexPaths.isEmpty && insertIndexPaths.isEmpty {
            return
        }
        
        collectionView.performBatchUpdates({
            collectionView.insertItemsAtIndexPaths(insertIndexPaths)
            collectionView.reloadItemsAtIndexPaths(reloadIndexPaths)
            collectionView.deleteItemsAtIndexPaths(deleteIndexPaths)
            }, completion: nil)
    }
    
    func highResImage(forIndex index: Int) -> UIImage? {
        if let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0)) as? ProductImageCell {
            return cell.image
        }
        return nil
    }
    
    func scrollToImage(atIndex index: Int) {
        collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .Top, animated: true)
    }
    
    func didEndDisplayingCell(cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let imageCell = cell as? ProductImageCellInterface {
            imageCell.didEndDisplaying()
        }
    }
    
    private func videoIndex(forCell cell: ProductImageVideoCell) -> Int? {
        guard let indexPath = collectionView?.indexPathForCell(cell) else { return nil }
        return indexPath.item - imageUrls.count
    }
    
    private func informVisibleCells<T>(@noescape about: T -> Void) {
        guard let collectionView = collectionView else { return }
        for cell in collectionView.visibleCells() {
            if let cell = cell as? T {
                about(cell)
            }
        }
    }
    
    // MARK:- ProductImageCellDelegate
    
    func productImageCell(cell: ProductImageCell, didDownloadImageWithSuccess success: Bool) {
        if let indexPath = collectionView?.indexPathForCell(cell) where indexPath.item == 0 {
            productPageView?.didDownloadFirstImage(withSuccess: success)
        }
    }
    
    // MARK:- ProductImageVideoCellDelegate
    
    func productImageVideoCellDidLoadVideo(cell: ProductImageVideoCell, asset: AVAsset) {
        guard let index = videoIndex(forCell: cell) else { return }
        productPageView?.didLoadVideo(atIndex: index, asset: asset)
    }
    
    func productImageVideoCellDidFinishVideo(cell: ProductImageVideoCell) {
        guard let index = videoIndex(forCell: cell) else { return }
        productPageView?.didFinishVideo(atIndex: index)
    }
    
    func productImageVideoCellFailedToLoadVideo(cell: ProductImageVideoCell) {
        guard let index = videoIndex(forCell: cell) else { return }
        productPageView?.didFailedToLoadVideo(atIndex: index)
    }
    
    // MARK:- UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let videoIndex = indexPath.row - imageUrls.count
        if let imageUrl = imageUrls[safe: indexPath.row] {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductImageCell), forIndexPath: indexPath) as! ProductImageCell
            cell.delegate = self
            cell.screenInset = screenInset
            cell.fullScreenInset = fullScreenInset
            cell.fullScreenMode = state == .FullScreen
            cell.update(withImageUrl: imageUrl, lowResImageUrl: indexPath.row == 0 ? lowResImageUrl : nil)
            return cell
        } else if let video = videos[safe: videoIndex] {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(String(ProductImageVideoCell), forIndexPath: indexPath) as! ProductImageVideoCell
            cell.delegate = self
            cell.screenInset = screenInset
            cell.fullScreenInset = fullScreenInset
            cell.fullScreenMode = state == .FullScreen
            cell.update(with: video) { [unowned self]in
                self.assetsFactory(videoIndex)
            }
            return cell
        } else {
            fatalError("Tried to retrieve cell for wrong index, indexPath: \(indexPath), videos: \(videos), imageUrls \(imageUrls)")
        }
    }
}
