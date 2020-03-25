import UIKit
import AudioToolbox

protocol ResultsViewControllerDelegate: class {
    func resultsViewControllerWillExpandResult()
    func resultsViewControllerDidCollapse()
}

class ResultsViewController: UIViewController {
    private let stackViewController = CardStackViewController()
    private let barcodeValidator: BarcodeValidator
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        addChild(stackViewController)
        view = ResultsView(frame: .zero, stackView: stackViewController.view as! CardStackView)
        stackViewController.didMove(toParent: self)
    }
    
    var castedView: ResultsView {
        view as! ResultsView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackViewController.delegate = self
        castedView.teachButton.addTarget(self, action: #selector(teachTapped), for: .touchUpInside)
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
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
        }
    }
    
    private func addCardAndDownloadDetails(_ barcode: String) -> Bool {
        let cardViewController = DI.container.resolve(ScanResultViewController.self, argument: barcode)!
        cardViewController.delegate = self
        return stackViewController.add(card: cardViewController)
    }
    
    @objc
    private func teachTapped() {
        lastResultViewController?.teachTapped()
    }
}

extension ResultsViewController: ScanResultViewControllerDelegate {
    func scanResultViewController(_ vc: ScanResultViewController, didFetchResult result: ScanResult) {
        let visible = result.ai?.askForPics ?? false
        castedView.teachButton.isHidden = !visible
        castedView.teachButton.setTitle(result.ai?.askForPicsPreview, for: .normal)
        castedView.teachButton.setNeedsLayout()
    }

    func scanResultViewController(_ vc: ScanResultViewController, didFailFetchingScanResultWithError error: Error) {
        let alertView = UIAlertView.showErrorAlert(R.string.localizable.cannotFetchProductInfoFromServerPleaseTryAgain())
        alertView.delegate = self
        stackViewController.remove(card: vc)
    }
    
    func scanResultViewControllerDidSentTeachReport(_ vc: ScanResultViewController) {
        castedView.teachButton.isHidden = true
        castedView.setNeedsLayout()
    }
    
}

extension ResultsViewController: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
       isAddingCardEnabled = true
    }
}

extension ResultsViewController: CardStackViewControllerDelegate {
    func stackViewControllerDidCollapse(_ stackViewController: CardStackViewController) {
        delegate?.resultsViewControllerDidCollapse()
        castedView.teachButton.isHidden = !(lastResultViewController?.scanResult?.ai?.askForPics ?? false)
        isAddingCardEnabled = true
    }
    
    func stackViewController(_ stackViewController: CardStackViewController, willAddCard card: UIViewController) {
        castedView.teachButton.isHidden = true
        castedView.setNeedsLayout()
    }
    
    func stackViewController(_ stackViewController: CardStackViewController, willExpandCard card: UIViewController) {
        delegate?.resultsViewControllerWillExpandResult()
        castedView.teachButton.isHidden = true
        isAddingCardEnabled = false
    }
    
}
