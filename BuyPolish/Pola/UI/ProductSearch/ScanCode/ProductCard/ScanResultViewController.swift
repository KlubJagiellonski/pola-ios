import PromiseKit
import UIKit

protocol ScanResultViewControllerDelegate: AnyObject {
    func scanResultViewController(_ vc: ScanResultViewController, didFetchResult result: ScanResult)
    func scanResultViewController(_ vc: ScanResultViewController, didFailFetchingScanResultWithError error: Error)
}

final class ScanResultViewController: UIViewController {
    let barcode: String
    private let productManager: ProductManager
    private let analytics: AnalyticsHelper
    private(set) var scanResult: ScanResult?

    weak var delegate: ScanResultViewControllerDelegate?

    init(barcode: String, productManager: ProductManager, analyticsProvider: AnalyticsProvider) {
        self.barcode = barcode
        self.productManager = productManager
        analytics = AnalyticsHelper(provider: analyticsProvider)
        super.init(nibName: nil, bundle: nil)
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
        }.done { [weak self, analytics] scanResult in
            analytics.received(productResult: scanResult)
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

    private func fillTitleLabel(scanResult: ScanResult) {
        if let name = scanResult.name, name.isNotEmpty {
            castedView.titleLabel.text = name
        } else if let company = scanResult.companies?.first {
            castedView.titleLabel.text = company.name
        }
    }

    private func fillReportButton(scanResult: ScanResult) {
        if let report = scanResult.report {
            castedView.reportProblemButton.setTitle(report.buttonText?.uppercased(), for: .normal)
            castedView.reportProblemButton.setReportType(report.buttonType)
            castedView.reportInfoLabel.text = report.text
        } else {
            castedView.reportProblemButton.isHidden = true
            castedView.reportInfoLabel.isHidden = true
        }
    }

    private func fillProgressView(scanResult: ScanResult) {
        if scanResult.companies?.count == 1,
            let company = scanResult.companies?.first,
            let plScore = company.plScore {
            castedView.mainProgressView.progress = CGFloat(plScore) / 100.0
        }
    }

    private func fillViewWithData(scanResult: ScanResult) {
        self.scanResult = scanResult
        let contentViewController = ResultContentViewControllerFactory.create(scanResult: scanResult)
        addChild(contentViewController)
        castedView.contentView = contentViewController.view
        contentViewController.didMove(toParent: self)

        fillTitleLabel(scanResult: scanResult)
        fillProgressView(scanResult: scanResult)

        switch scanResult.cardType {
        case .grey:
            view.backgroundColor = Theme.mediumBackgroundColor
            castedView.mainProgressView.backgroundColor = Theme.strongBackgroundColor
        case .white:
            view.backgroundColor = Theme.clearColor
            castedView.mainProgressView.backgroundColor = Theme.lightBackgroundColor
        }

        fillReportButton(scanResult: scanResult)
        castedView.heartImageView.isHidden = !scanResult.isFriend

        UIAccessibility.post(notification: .screenChanged, argument: castedView.titleLabel)
    }

    func setExpandedCard() {
        castedView.titleLabel.numberOfLines = 0
        castedView.heartImageView.isHidden = true
        castedView.setNeedsLayout()
    }

    func setCollapsedCard() {
        if let scanResult = self.scanResult {
            castedView.titleLabel.numberOfLines = 1
            castedView.heartImageView.isHidden = scanResult.isNotFriend
            castedView.setNeedsLayout()
        }
    }

    @objc
    private func reportProblemTapped() {
        guard let productId = scanResult?.productId else {
            return
        }
        analytics.reportShown(barcode: barcode)
        let vc = DI.container.resolve(ReportProblemViewController.self,
                                      argument: ReportProblemReason.product(productId, barcode))!
        present(vc, animated: true, completion: nil)
    }

    @objc
    func polasFriendsButtonTapped() {
        analytics.polasFriendsOpened()
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
            analytics.opensCard(productResult: scanResult)
        }
    }

    func willBecameExpandedCard() {
        setExpandedCard()
    }

    func willBecameCollapsedCard() {
        setCollapsedCard()
    }
}
