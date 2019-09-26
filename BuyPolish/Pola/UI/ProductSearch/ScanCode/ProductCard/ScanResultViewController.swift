import UIKit

@objc
protocol ScanResultViewControllerDelegate: class {
    func scanResultViewController(_ vc: ScanResultViewController, didFetchResult result: BPScanResult)
    func scanResultViewController(_ vc: ScanResultViewController, didFailFetchingScanResultWithError error: Error)
    func scanResultViewControllerDidSentTeachReport(_ vc: ScanResultViewController)
}

class ScanResultViewController: UIViewController {
    let barcode: String
    private let productManager: BPProductManager
    private(set) var scanResult: BPScanResult?
    
    @objc
    weak var delegate: ScanResultViewControllerDelegate?
    
    @objc
    init(barcode: String, productManager: BPProductManager) {
        self.barcode = barcode
        self.productManager = productManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = ScanResultView()
    }
    
    private var castedView: ScanResultView {
        return view as! ScanResultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        castedView.reportProblemButton.addTarget(self, action: #selector(reportProblemTapped), for: .touchUpInside)
        castedView.teachButton.addTarget(self, action: #selector(teachTapped), for: .touchUpInside)

        downloadScanResult()
    }
    
    private func downloadScanResult() {
        castedView.titleLabel.text = R.string.localizable.loading()
        castedView.loadingProgressView.startAnimating()
        productManager.retrieveProduct(withBarcode: barcode,
                                        completion: { [weak self] (scanResult, error) in
                                            guard let `self` = self else {
                                                 return
                                            }
                                            self.castedView.loadingProgressView.stopAnimating()
                                            if let scanResult = scanResult {
                                                AnalyticsHelper.received(productResult: scanResult)
                                                self.fillViewWithData(scanResult: scanResult)
                                                self.delegate?.scanResultViewController(self, didFetchResult: scanResult)
                                            } else if let error = error {
                                                self.delegate?.scanResultViewController(self, didFailFetchingScanResultWithError: error)
                                            }
        }, completionQueue: OperationQueue.main)
    }
    
    private func fillViewWithData(scanResult: BPScanResult) {
        self.scanResult = scanResult
        let contentViewController = ResultContentViewControllerFactory.create(scanResult: scanResult)
        addChild(contentViewController)
        castedView.contentView = contentViewController.view
        contentViewController.didMove(toParent: self)
        
        castedView.titleLabel.text = scanResult.name

        if let plScore = scanResult.plScore?.intValue {
            castedView.mainProgressView.progress = CGFloat(plScore / 100)
        }
        
        if scanResult.askForPics,
            let askForPicsPreview = scanResult.askForPicsPreview,
            !askForPicsPreview.isEmpty{
            castedView.teachButton.setTitle(askForPicsPreview, for: .normal)
            castedView.teachButton.isHidden = false
        } else {
            castedView.teachButton.isHidden = true
        }
        
        switch scanResult.cardType {
        case CardTypeGrey:
            view.backgroundColor = Theme.mediumBackgroundColor
            castedView.mainProgressView.backgroundColor = Theme.strongBackgroundColor
        case CardTypeWhite:
            view.backgroundColor = Theme.clearColor
            castedView.mainProgressView.backgroundColor = Theme.lightBackgroundColor
        default:
            break
        }
        
        castedView.reportProblemButton.setTitle(scanResult.reportButtonText?.uppercased(), for: .normal)
        switch scanResult.reportButtonType {
        case ReportButtonTypeRed:
            castedView.reportProblemButton.setTitleColor(Theme.clearColor, for: .normal)
            castedView.reportProblemButton.setBackgroundImage(BPUtilities.image(with: Theme.actionColor), for: .normal)
        case ReportButtonTypeWhite:
            castedView.reportProblemButton.layer.borderColor = Theme.actionColor.cgColor
            castedView.reportProblemButton.layer.borderWidth = 1
            castedView.reportProblemButton.setTitleColor(Theme.actionColor, for: .normal)
            castedView.reportProblemButton.setTitleColor(Theme.clearColor, for: .highlighted)
            castedView.reportProblemButton.setBackgroundImage(BPUtilities.image(with: UIColor.clear), for: .normal)
            castedView.reportProblemButton.setBackgroundImage(BPUtilities.image(with: Theme.actionColor), for: .highlighted)
        default:
            break
        }

        castedView.reportInfoLabel.text = scanResult.reportText
        castedView.heartImageView.isHidden = !scanResult.isFriend
        
        UIAccessibility.post(notification: .screenChanged, argument: castedView.titleLabel)

    }
    
    @objc
    func reportProblemTapped() {
        guard let productId = scanResult?.productId else {
            return
        }
        AnalyticsHelper.reportShown(barcode: barcode)
        let reportProblemViewController = BPReportProblemViewController(productId: productId, barcode: barcode)
        reportProblemViewController.delegate = self
        present(reportProblemViewController, animated: true, completion: nil)
    }
    
    @objc
    func teachTapped() {
        guard let scanResult = scanResult else {
            return
        }
        AnalyticsHelper.teachReportShow(barcode: barcode)
        let captureVideoNavigationController = BPCaptureVideoNavigationController(scanResult: scanResult)
        captureVideoNavigationController.captureDelegate = self
        present(captureVideoNavigationController, animated: true, completion: nil)
    }

}

extension ScanResultViewController: BPReportProblemViewControllerDelegate {
    func reportProblemWantsDismiss(_ viewController: BPReportProblemViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func reportProblem(_ controller: BPReportProblemViewController, finishedWithResult result: Bool) {
        dismiss(animated: true, completion: nil)
    }
}

extension ScanResultViewController: BPCaptureVideoNavigationControllerDelegate {
    func captureVideoNavigationController(_ controller: BPCaptureVideoNavigationController, wantsDismissWithSuccess success: Bool) {
        if success {
            delegate?.scanResultViewControllerDidSentTeachReport(self)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
