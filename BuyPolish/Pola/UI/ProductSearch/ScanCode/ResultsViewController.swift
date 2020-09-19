import AudioToolbox
import UIKit

protocol ResultsViewControllerDelegate: AnyObject {
    func resultsViewControllerDidExpandResult()
    func resultsViewControllerWillExpandResult()
    func resultsViewControllerDidCollapse()
}

final class ResultsViewController: UIViewController {
    private let stackViewController = CardStackViewController()
    private let barcodeValidator: BarcodeValidator
    private var donateURL: URL?

    weak var delegate: ResultsViewControllerDelegate?

    fileprivate var isAddingCardEnabled: Bool = true {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = isAddingCardEnabled
        }
    }

    private var lastResultViewController: ScanResultViewController? {
        stackViewController.cards.last as? ScanResultViewController
    }

    init(barcodeValidator: BarcodeValidator) {
        self.barcodeValidator = barcodeValidator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        addChild(stackViewController)
        view = ResultsView(frame: .zero, stackView: stackViewController.castedView)
        stackViewController.didMove(toParent: self)
    }

    var castedView: ResultsView! {
        view as? ResultsView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewController.delegate = self
        castedView.donateButton.addTarget(self, action: #selector(donateTapped), for: .touchUpInside)
    }

    func add(barcodeCard barcode: String, sourceType: AnalyticsBarcodeSource) {
        guard isAddingCardEnabled,
            lastResultViewController?.barcode != barcode else {
            return
        }

        guard barcodeValidator.isValid(barcode: barcode) else {
            isAddingCardEnabled = false
            let alertView = UIAlertView.showErrorAlert(R.string.localizable.notValidBarcodePleaseTryAgain())
            alertView.delegate = self
            return
        }

        if addCardAndDownloadDetails(barcode) {
            AnalyticsHelper.barcodeScanned(barcode, type: sourceType)
            castedView.infoTextVisible = false
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        }
    }

    private func addCardAndDownloadDetails(_ barcode: String) -> Bool {
        let cardViewController = DI.container.resolve(ScanResultViewController.self, argument: barcode)!
        cardViewController.delegate = self
        return stackViewController.add(card: cardViewController)
    }

    @objc
    private func donateTapped() {
        AnalyticsHelper.donateOpened(barcode: lastResultViewController?.barcode)
        if let donateURL = donateURL {
            UIApplication.shared.openURL(donateURL)
        }
    }
}

extension ResultsViewController: ScanResultViewControllerDelegate {
    func scanResultViewController(_: ScanResultViewController, didFetchResult result: ScanResult) {
        let visible = result.donate?.showButton ?? false
        castedView.donateButton.isHidden = !visible
        castedView.donateButton.setTitle(result.donate?.title, for: .normal)
        donateURL = result.donate?.url
        castedView.donateButton.setNeedsLayout()
    }

    func scanResultViewController(_ vc: ScanResultViewController, didFailFetchingScanResultWithError _: Error) {
        let alertView = UIAlertView.showErrorAlert(R.string.localizable.cannotFetchProductInfoFromServerPleaseTryAgain())
        alertView.delegate = self
        stackViewController.remove(card: vc)
    }
}

extension ResultsViewController: UIAlertViewDelegate {
    func alertView(_: UIAlertView, clickedButtonAt _: Int) {
        isAddingCardEnabled = true
    }
}

extension ResultsViewController: CardStackViewControllerDelegate {
    func stackViewControllerDidCollapse(_: CardStackViewController) {
        delegate?.resultsViewControllerDidCollapse()
        castedView.donateButton.isHidden = !(lastResultViewController?.scanResult?.donate?.showButton ?? false)
        isAddingCardEnabled = true
    }

    func stackViewController(_: CardStackViewController, willAddCard _: UIViewController) {
        castedView.donateButton.isHidden = true
        castedView.setNeedsLayout()
    }

    func stackViewController(_: CardStackViewController, willExpandCard _: UIViewController) {
        delegate?.resultsViewControllerWillExpandResult()
        castedView.donateButton.isHidden = true
        isAddingCardEnabled = false
    }

    func stackViewController(_: CardStackViewController, didExpandCard _: UIViewController) {
        delegate?.resultsViewControllerDidExpandResult()
        castedView.donateButton.isHidden = true
    }

    func stackViewController(_: CardStackViewController, startPickingCard _: UIViewController) {
        castedView.donateButton.isHidden = true
    }
}
