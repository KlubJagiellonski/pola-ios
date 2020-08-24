import PromiseKit
import UIKit

protocol ScanResultViewControllerDelegate: AnyObject {
    func scanResultViewController(_ vc: ScanResultViewController, didFetchResult result: ScanResult)
    func scanResultViewController(_ vc: ScanResultViewController, didFailFetchingScanResultWithError error: Error)
}

final class ScanResultViewController: UIViewController {
    let barcode: String
    private let productManager: ProductManager
    private(set) var scanResult: ScanResult?

    weak var delegate: ScanResultViewControllerDelegate?

    init(barcode: String, productManager: ProductManager) {
        self.barcode = barcode
        self.productManager = productManager
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(barcode: String) {
        self.init(barcode: barcode, productManager: DI.container.resolve(ProductManager.self)!)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ScanResultView()
    }

    private var castedView: ScanResultView! {
        return view as? ScanResultView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        castedView.reportProblemButton.addTarget(self, action: #selector(reportProblemTapped), for: .touchUpInside)
        castedView.polasFriendsButton.addTarget(self, action: #selector(polasFriendsButtonTapped), for: .touchUpInside)

        downloadScanResult()
    }

    private func downloadScanResult() {
        castedView.titleLabel.text = R.string.localizable.loading()
        castedView.loadingProgressView.startAnimating()
        firstly {
            productManager.retrieveProduct(barcode: barcode)
        }.done { [weak self] scanResult in
            AnalyticsHelper.received(productResult: scanResult)
            if let self = self {
                self.fillViewWithData(scanResult: scanResult)
                self.delegate?.scanResultViewController(self, didFetchResult: scanResult)
            }
        }.ensure { [castedView] in
            castedView?.loadingProgressView.stopAnimating()
        }.catch { [weak self] error in
            if let self = self {
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
    private func reportProblemTapped() {
        guard let productId = scanResult?.productId else {
            return
        }
        AnalyticsHelper.reportShown(barcode: barcode)
        let vc = DI.container.resolve(ReportProblemViewController.self,
                                      argument: ReportProblemReason.product(productId, barcode))!
        present(vc, animated: true, completion: nil)
    }

    @objc
    func polasFriendsButtonTapped() {
        AnalyticsHelper.polasFriendsOpened()
        let vc = AboutWebViewController(url: "https://www.pola-app.pl/m/friends",
                                        title: R.string.localizable.polaSFriends())
        vc.addCloseButton()
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
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
