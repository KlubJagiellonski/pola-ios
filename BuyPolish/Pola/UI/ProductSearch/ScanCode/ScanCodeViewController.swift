import KVNProgress
import MobileCoreServices
import Observable
import PromiseKit
import UIKit

final class ScanCodeViewController: UIViewController {
    private var keyboardViewController: KeyboardViewController?
    private let flashlightManager: FlashlightManager
    private let scanningCodeViewController: ScanningViewController
    fileprivate let resultsViewController: ResultsViewController
    private let animationTime = TimeInterval(0.15)
    private var disposable: Disposable?
    private let analytics: AnalyticsHelper
    private lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = [String(kUTTypeImage)]
        picker.sourceType = .photoLibrary
        return picker
    }()

    private lazy var barcodeDetector = BarcodeDetector()

    init(flashlightManager: FlashlightManager, analyticsProvider: AnalyticsProvider) {
        self.flashlightManager = flashlightManager
        analytics = AnalyticsHelper(provider: analyticsProvider)
        scanningCodeViewController = DI.container.resolve(ScanningViewController.self)!
        resultsViewController = DI.container.resolve(ResultsViewController.self)!

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ScanCodeView()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    fileprivate var castedView: ScanCodeView! {
        view as? ScanCodeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addChild(scanningCodeViewController)
        view.insertSubview(scanningCodeViewController.view, at: 0)
        scanningCodeViewController.didMove(toParent: self)
        scanningCodeViewController.scannerDelegate = self

        addChild(resultsViewController)
        view.insertSubview(resultsViewController.view, belowSubview: castedView.logoButton)
        resultsViewController.didMove(toParent: self)
        resultsViewController.delegate = self

        castedView.menuButton.addTarget(self, action: #selector(tapMenuButton), for: .touchUpInside)
        castedView.keyboardButton.addTarget(self, action: #selector(tapKeyboardButton), for: .touchUpInside)
        castedView.logoButton.addTarget(self, action: #selector(tapLogoButton), for: .touchUpInside)
        castedView.galleryButton.addTarget(self, action: #selector(tapGalleryButton), for: .touchUpInside)

        if flashlightManager.isAvailable {
            castedView.flashButton.addTarget(self, action: #selector(tapFlashlightButton), for: .touchUpInside)
        } else {
            #if !targetEnvironment(simulator)
                castedView.flashButton.isHidden = true
            #endif
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let flashButton = castedView.flashButton
        disposable = flashlightManager.isOn.observe { [flashButton] newValue, _ in
            flashButton.isSelected = newValue
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposable?.dispose()
        disposable = nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        keyboardViewController?.view.frame = view.bounds
        scanningCodeViewController.view.frame = view.bounds
        resultsViewController.view.frame = view.bounds
    }

    func showScanCodeView() {
        dismiss(animated: true, completion: nil)
        hideKeyboardController()
    }

    func showWriteCodeView() {
        dismiss(animated: true, completion: nil)
        showKeyboardController()
    }

    @objc
    private func tapMenuButton() {
        analytics.aboutOpened(windowName: .menu)

        let vc = AboutViewController(analyticsProvider: DI.container.resolve(AnalyticsProvider.self)!)
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    @objc
    private func tapKeyboardButton() {
        if keyboardViewController == nil {
            showKeyboardController()
        } else {
            hideKeyboardController()
        }
    }

    @objc
    func tapFlashlightButton() {
        flashlightManager.toggle { _ in
            // TODO: Add error message after consultation with UX
        }
    }

    @objc
    func tapLogoButton() {
        analytics.aboutPolaOpened()
        let vc = AboutWebViewController(url: "https://www.pola-app.pl/m/about",
                                        title: R.string.localizable.aboutPolaApplication())
        vc.addCloseButton()
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    @objc
    private func tapGalleryButton() {
        castedView.galleryButton.isSelected = true
        present(imagePicker, animated: true, completion: nil)
        imagePicker.presentationController?.delegate = self
        analytics.openGallery()
    }

    fileprivate func hideKeyboardController() {
        guard let keyboardViewController = keyboardViewController else {
            return
        }

        castedView.keyboardButton.isSelected = false
        keyboardViewController.willMove(toParent: nil)
        UIView.animate(withDuration: animationTime, animations: { [resultsViewController, scanningCodeViewController] in
            resultsViewController.view.alpha = 1.0
            scanningCodeViewController.view.alpha = 1.0
            keyboardViewController.view.alpha = 0.0
        }, completion: { [weak self, keyboardViewController] _ in
            keyboardViewController.view.removeFromSuperview()
            self?.keyboardViewController = nil
        })
    }

    fileprivate func showKeyboardController() {
        guard keyboardViewController == nil else {
            return
        }

        castedView.keyboardButton.isSelected = true
        let keyboardViewController = DI.container.resolve(KeyboardViewController.self)!
        keyboardViewController.delegate = self

        addChild(keyboardViewController)
        keyboardViewController.view.frame = view.bounds
        keyboardViewController.view.alpha = 0.0
        view.insertSubview(keyboardViewController.view, belowSubview: castedView.logoButton)

        UIView.animate(withDuration: animationTime,
                       animations: { [resultsViewController, scanningCodeViewController] in
                           keyboardViewController.view.alpha = 1.0
                           resultsViewController.view.alpha = 0.0
                           scanningCodeViewController.view.alpha = 0.0
                       }, completion: { _ in
                           keyboardViewController.didMove(toParent: self)
                       })
        self.keyboardViewController = keyboardViewController
    }
}

extension ScanCodeViewController: ScanningDelegate {
    func didScan(barcode: String, sourceType: AnalyticsBarcodeSource) {
        resultsViewController.add(barcodeCard: barcode, sourceType: sourceType)
    }
}

extension ScanCodeViewController: KeyboardViewControllerDelegate {
    func keyboardViewController(_: KeyboardViewController, didConfirmWithCode code: String) {
        hideKeyboardController()
        resultsViewController.add(barcodeCard: code, sourceType: .keyboard)
    }
}

extension ScanCodeViewController: ResultsViewControllerDelegate {
    func resultsViewControllerDidExpandResult() {
        castedView.setButtonsVisible(false, animated: false)
    }

    func resultsViewControllerWillExpandResult() {
        castedView.setButtonsVisible(false, animated: true)
    }

    func resultsViewControllerDidCollapse() {
        castedView.setButtonsVisible(true, animated: true)
    }
}

extension ScanCodeViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        imagePicker.dismiss(animated: true)
        castedView.galleryButton.isSelected = false

        KVNProgress.show(withStatus: R.string.localizable.searchingForBarcode())

        guard let editedImage = info[.editedImage] as? UIImage else {
            KVNProgress.showError(withStatus: R.string.localizable.barcodeNotFound())
            BPLog("Error, image not recognized.")
            return
        }

        barcodeDetector
            .getBarcodeFromImage(editedImage)
            .done(on: .main) { [weak self] code in
                KVNProgress.dismiss()
                if let code = code {
                    self?.didScan(barcode: code, sourceType: .photos)
                    BPLog("Found barcode \(code) on an image from Photos.")
                } else {
                    KVNProgress.showError(withStatus: R.string.localizable.barcodeNotFound())
                    BPLog("Error, barcode not found on an image from Photos.")
                    self?.analytics.barcodeNotFoundOnPhotoDisplayed()
                }
            }
            .catch { _ in
                KVNProgress.showError(withStatus: R.string.localizable.barcodeNotFound())
                BPLog("Error, image not recognized.")
            }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        castedView.galleryButton.isSelected = false
    }
}

extension ScanCodeViewController: UINavigationControllerDelegate {}

extension ScanCodeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_: UIPresentationController) {
        castedView.galleryButton.isSelected = false
    }
}
