import Foundation

extension ScanResult {
    
    var bpScanResult: BPScanResult {
        let bp = BPScanResult()
        bp.productId = NSNumber(value: productId)
        bp.code = code
        bp.name = name
        switch cardType {
        case .white:
            bp.cardType = CardTypeWhite
        case .grey:
            bp.cardType = CardTypeGrey
        }
        bp.plScore = number(from: plScore)
        bp.altText = altText
        bp.plCapital = number(from: plCapital)
        bp.plWorkers = number(from: plWorkers)
        bp.plRnD = number(from: plRnD)
        bp.plRegistered = number(from: plRegistered)
        bp.plNotGlobEnt = number(from: plNotGlobEnt)
        bp.descr = description
        bp.reportText = reportText
        bp.reportButtonText = reportButtonText
        switch reportButtonType {
        case .white:
            bp.reportButtonType = ReportButtonTypeWhite
        case .red:
            bp.reportButtonType = ReportButtonTypeRed
        }
        bp.askForPics = ai?.askForPics ?? false
        bp.isFriend = isFriend ?? false
        bp.askForPicsPreview = ai?.askForPicsPreview
        bp.askForPicsTitle = ai?.askForPicsTitle
        bp.askForPicsText = ai?.askForPicsText
        bp.askForPicsButtonStart = ai?.askForPicsButtonStart
        bp.askForPicsProduct = ai?.askForPicsProduct
        bp.maxPicSize = number(from: ai?.maxPicSize)
        return bp
    }
    
    private func number(from int: Int?) -> NSNumber? {
        guard let int = int else {
            return nil
        }
        return NSNumber(value: int)
    }
    
    private func number(from double: Double?) -> NSNumber? {
        guard let double = double else {
            return nil
        }
        return NSNumber(value: double)
    }

}
