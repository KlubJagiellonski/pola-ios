import Observable
import UIKit

final class ScanCodeViewController: UIViewController {
    private var keyboardViewController: KeyboardViewController?
    private let flashlightManager: FlashlightManager
    private let scannerCodeViewController: ScannerCodeViewController
    fileprivate let resultsViewController: ResultsViewController
    private let animationTime = TimeInterval(0.15)
    private var disposable: Disposable?

    init(flashlightManager: FlashlightManager) {
        self.flashlightManager = flashlightManager
        scannerCodeViewController = DI.container.resolve(ScannerCodeViewController.self)!
        resultsViewController = DI.container.resolve(ResultsViewController.self)!

        super.init(nibName: nil, bundle: nil)
    }

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

        addChild(scannerCodeViewController)
        view.insertSubview(scannerCodeViewController.view, at: 0)
        scannerCodeViewController.didMove(toParent: self)
        scannerCodeViewController.scannerDelegate = self

        addChild(resultsViewController)
        view.insertSubview(resultsViewController.view, belowSubview: castedView.logoButton)
        resultsViewController.didMove(toParent: self)
        resultsViewController.delegate = self

        automaticallyAdjustsScrollViewInsets = false
        castedView.menuButton.addTarget(self, action: #selector(tapMenuButton), for: .touchUpInside)
        castedView.keyboardButton.addTarget(self, action: #selector(tapKeyboardButton), for: .touchUpInside)
        castedView.logoButton.addTarget(self, action: #selector(tapLogoButton), for: .touchUpInside)

        if flashlightManager.isAvailable {
            castedView.flashButton.addTarget(self, action: #selector(tapFlashlightButton), for: .touchUpInside)
        } else {
            castedView.flashButton.isHidden = true
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
        scannerCodeViewController.view.frame = view.bounds
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
        AnalyticsHelper.aboutOpened(windowName: .menu)

        let vc = AboutViewController()
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
        AnalyticsHelper.aboutPolaOpened()
        let vc = AboutWebViewController(url: "https://www.pola-app.pl/m/about",
                                        title: R.string.localizable.polaSFriends())
        vc.addCloseButton()
        let nvc = UINavigationController(rootViewController: vc)
        present(nvc, animated: true, completion: nil)
    }

    fileprivate func hideKeyboardController() {
        guard let keyboardViewController = keyboardViewController else {
            return
        }

        castedView.keyboardButton.isSelected = false
        keyboardViewController.willMove(toParent: nil)
        UIView.animate(withDuration: animationTime, animations: { [resultsViewController, scannerCodeViewController] in
            resultsViewController.view.alpha = 1.0
            scannerCodeViewController.view.alpha = 1.0
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
                       animations: { [resultsViewController, scannerCodeViewController] in
                           keyboardViewController.view.alpha = 1.0
                           resultsViewController.view.alpha = 0.0
                           scannerCodeViewController.view.alpha = 0.0
                       }, completion: { _ in
                           keyboardViewController.didMove(toParent: self)
        })
        self.keyboardViewController = keyboardViewController
    }
}

extension ScanCodeViewController: CodeScannerManagerDelegate {
    func didScan(barcode: String) {
        resultsViewController.add(barcodeCard: barcode, sourceType: .camera)
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
