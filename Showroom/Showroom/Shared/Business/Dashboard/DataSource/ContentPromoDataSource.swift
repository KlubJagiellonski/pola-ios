import Foundation
import UIKit

class ContentPromoDataSource : NSObject, UITableViewDataSource {
    private let numberOfSections = 3
    private let numberOfRowsInRecommendationsSection = 2
    private var numberOfContentPromosInFirstSection: Int {
        return contentPromos.count == 0 ? 0 : 1
    }
    private let recommendationsSectionIndex = 1
    
    private var contentPromos: [ContentPromo] = []
    private weak var tableView: UITableView?
    
    weak var recommendationCollectionViewDelegate: UICollectionViewDelegate?
    let recommendationsDataSource = ProductRecommendationDataSource()
    
    init(tableView: UITableView) {
        super.init()
        
        self.tableView = tableView
        tableView.registerClass(ContentPromoCell.self, forCellReuseIdentifier: String(ContentPromoCell))
        tableView.registerClass(ContentPromoWithCaptionCell.self, forCellReuseIdentifier: String(ContentPromoWithCaptionCell))
        tableView.registerClass(ContentPromoRecommendationsHeaderCell.self, forCellReuseIdentifier: String(ContentPromoRecommendationsHeaderCell))
        tableView.registerClass(ContentPromoRecommendationsCell.self, forCellReuseIdentifier: String(ContentPromoRecommendationsCell))
    }
    
    func changeData(contentPromos: [ContentPromo]) {
        //TODO add animations
        self.contentPromos = contentPromos
        tableView?.reloadData()
    }
    
    func getHeightForRow(atIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let width = tableView?.frame.size.width else { return 0.0 }
        
        if let contentPromoIndex = contentPromoIndex(with: indexPath) {
            let contentPromo = contentPromos[contentPromoIndex]
            return contentPromo.caption == nil ? ContentPromoCell.getHeight(forWidth: width, model: contentPromo) : ContentPromoWithCaptionCell.getHeight(forWidth: width, model: contentPromo)
        } else {
            return indexPath.row == 0 ? ContentPromoRecommendationsHeaderCell.cellHeight : ContentPromoRecommendationsCell.cellHeight
        }
    }
    
    func getDataForRow(atIndexPath indexPath: NSIndexPath) -> ContentPromo? {
        guard let index = contentPromoIndex(with: indexPath) else { return nil }
        return contentPromos[index]
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recommendationsSectionIndex == section {
            return numberOfRowsInRecommendationsSection
        } else if section == 0 {
            return numberOfContentPromosInFirstSection
        } else {
            return contentPromos.count - numberOfContentPromosInFirstSection
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let contentPromoIndex = contentPromoIndex(with: indexPath) {
            let contentPromo = contentPromos[contentPromoIndex]
            let cellIdentifier = contentPromo.caption == nil ? String(ContentPromoCell) : String(ContentPromoWithCaptionCell)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContentPromoCell
            cell.selectionStyle = .None
            cell.updateData(contentPromo)
            return cell
        } else {
            return createRecommendationCell(tableView, atIndexPath: indexPath)
        }
    }
    
    func createRecommendationCell(tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ContentPromoRecommendationsHeaderCell), forIndexPath: indexPath)
            cell.selectionStyle = .None
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(String(ContentPromoRecommendationsCell), forIndexPath: indexPath) as! ContentPromoRecommendationsCell
            cell.collectionView.dataSource = recommendationsDataSource
            cell.selectionStyle = .None
            cell.collectionView.delegate = recommendationCollectionViewDelegate
            recommendationsDataSource.collectionView = cell.collectionView
            recommendationsDataSource.viewSwitcher = cell.viewSwitcher
            return cell
        }
    }
    
    private func contentPromoIndex(with indexPath: NSIndexPath) -> Int? {
        guard indexPath.section != recommendationsSectionIndex else {
            return nil
        }
        
        if indexPath.section == 0 {
            return indexPath.row
        } else {
            return indexPath.row + numberOfContentPromosInFirstSection
        }
    }
}