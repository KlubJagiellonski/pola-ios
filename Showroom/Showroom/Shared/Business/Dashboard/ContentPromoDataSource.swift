import Foundation
import UIKit

class ContentPromoDataSource : NSObject, UITableViewDataSource {
    
    private var contentPromos: [ContentPromo] = []
    private weak var tableView: UITableView?
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        tableView.registerClass(ContentPromoCell.self, forCellReuseIdentifier: String(ContentPromoCell))
        tableView.registerClass(ContentPromoWithCaptionCell.self, forCellReuseIdentifier: String(ContentPromoWithCaptionCell))
    }
    
    func changeData(contentPromos: [ContentPromo]) {
        //TODO add animations
        self.contentPromos = contentPromos
        tableView?.reloadData()
    }
    
    func getHeightForRow(atIndexPath indexPath: NSIndexPath) -> CGFloat {
        guard let width = tableView?.frame.size.width else { return 0.0 }
        let contentPromo = contentPromos[indexPath.row]
        return contentPromo.caption == nil ? ContentPromoCell.getHeight(forWidth: width, model: contentPromo) : ContentPromoWithCaptionCell.getHeight(forWidth: width, model: contentPromo)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentPromos.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let contentPromo = contentPromos[indexPath.row]
        let cellIdentifier = contentPromo.caption == nil ? String(ContentPromoCell) : String(ContentPromoWithCaptionCell)
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ContentPromoCell
        cell.updateData(contentPromo)
        return cell
    }
}
