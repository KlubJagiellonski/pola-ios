import UIKit

@objc
protocol ScanResultViewControllerDelegate: class {
    func scanResultViewController(_ vc: ScanResultViewController, didFetchResult result: BPScanResult)
    func scanResultViewController(_ vc: ScanResultViewController, didFailFetchingScanResultWithError error: Error)
    func scanResultViewControllerDidSentTeachReport(_ vc: ScanResultViewController)
}

class ScanResultViewController: UIViewController {
    let barcode: String
    private let productManager: ProductManager
    private(set) var scanResult: ScanResult?
    
    @objc
    weak var delegate: ScanResultViewControllerDelegate?
    
    init(barcode: String, productManager: ProductManager) {
        self.barcode = barcode
        self.productManager = productManager
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc
    convenience init(barcode: String) {
        self.init(barcode: barcode, productManager: ProductManager())
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
        productManager.retrieveProduct(barcode: barcode) { [weak self] (result) in
            guard let `self` = self else {
                 return
            }
            self.castedView.loadingProgressView.stopAnimating()

            switch result {
            case .success(let scanResult):
                AnalyticsHelper.received(productResult: scanResult)
                self.fillViewWithData(scanResult: scanResult)
                self.delegate?.scanResultViewController(self, didFetchResult: scanResult.bpScanResult)
                
            case .failure(let error):
                self.delegate?.scanResultViewController(self, didFailFetchingScanResultWithError: error)
            }

        }
    }
    
    private func fillViewWithData(scanResult: ScanResult) {
        self.scanResult = scanResult
        let contentViewController = ResultContentViewControllerFactory.create(scanResult: scanResult)
        addChild(contentViewController)
        castedView.contentView = contentViewController.view
        contentViewController.didMove(toParent: self)
        
        castedView.titleLabel.text = scanResult.name

        if let plScore = scanResult.plScore {
            castedView.mainProgressView.progress = CGFloat(plScore) / 100.0
        }
        
        if let ai = scanResult.ai,
            ai.askForPics,
            !ai.askForPicsPreview.isEmpty {
            castedView.teachButton.setTitle(ai.askForPicsPreview, for: .normal)
            castedView.teachButton.isHidden = false
        } else {
            castedView.teachButton.isHidden = true
        }
        
        switch scanResult.cardType {
        case .grey:
            view.backgroundColor = Theme.mediumBackgroundColor
            castedView.mainProgressView.backgroundColor = Theme.strongBackgroundColor
        case .white:
            view.backgroundColor = Theme.clearColor
            castedView.mainProgressView.backgroundColor = Theme.lightBackgroundColor
        }
        
        castedView.reportProblemButton.setTitle(scanResult.reportButtonText?.uppercased(), for: .normal)
        switch scanResult.reportButtonType {
        case .red:
            castedView.reportProblemButton.setTitleColor(Theme.clearColor, for: .normal)
            castedView.reportProblemButton.setBackgroundImage(UIImage.image(color: Theme.actionColor), for: .normal)
        case .white:
            castedView.reportProblemButton.layer.borderColor = Theme.actionColor.cgColor
            castedView.reportProblemButton.layer.borderWidth = 1
            castedView.reportProblemButton.setTitleColor(Theme.actionColor, for: .normal)
            castedView.reportProblemButton.setTitleColor(Theme.clearColor, for: .highlighted)
            castedView.reportProblemButton.setBackgroundImage(UIImage.image(color: UIColor.clear), for: .normal)
            castedView.reportProblemButton.setBackgroundImage(UIImage.image(color: Theme.actionColor), for: .highlighted)
        }

        castedView.reportInfoLabel.text = scanResult.reportText
        castedView.heartImageView.isHidden = !(scanResult.isFriend ?? false)
        
        UIAccessibility.post(notification: .screenChanged, argument: castedView.titleLabel)

    }
    
    @objc
    func reportProblemTapped() {
        guard let productId = scanResult?.productId else {
            return
        }
        AnalyticsHelper.reportShown(barcode: barcode)
        let reportProblemViewController = BPReportProblemViewController(productId: NSNumber(value: productId), barcode: barcode)
        reportProblemViewController.delegate = self
        present(reportProblemViewController, animated: true, completion: nil)
    }
    
    @objc
    func teachTapped() {
        guard let scanResult = scanResult else {
            return
        }
        AnalyticsHelper.teachReportShow(barcode: barcode)
        let captureVideoNavigationController = BPCaptureVideoNavigationController(scanResult: scanResult.bpScanResult)
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

extension ScanResultViewController: CardStackViewControllerCard {
    var titleHeight: CGFloat {
        get {
            castedView.titleHeight
        }
        set {
            castedView.titleHeight = newValue
        }
    }
    
    func didBecameExpandedCard() {
        castedView.scrollViewForContentView.flashScrollIndicators()
        if let scanResult = scanResult {
            AnalyticsHelper.opensCard(productResult: scanResult)
        }
    }
}
