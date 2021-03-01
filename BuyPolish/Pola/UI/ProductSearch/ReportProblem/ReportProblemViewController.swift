import KVNProgress
import PromiseKit
import UIKit

final class ReportProblemViewController: UIViewController {
    private let productImageManager: ProductImageManager
    private let reportManager: ReportManager
    private let keyboardManager: KeyboardManager
    private let reason: ReportProblemReason
    private let analytics: AnalyticsHelper
    private let isImageEnabled: Bool
    private var imageCount: Int = 0

    private var castedView: ReportProblemView! {
        view as? ReportProblemView
    }

    init(reason: ReportProblemReason,
         productImageManager: ProductImageManager,
         reportManager: ReportManager,
         keyboardManager: KeyboardManager,
         analyticsProvider: AnalyticsProvider,
         isImageEnabled: Bool = false) {
        self.reason = reason
        self.productImageManager = productImageManager
        self.reportManager = reportManager
        self.keyboardManager = keyboardManager
        self.isImageEnabled = isImageEnabled
        analytics = AnalyticsHelper(provider: analyticsProvider)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = ReportProblemView(isImageEnabled: isImageEnabled)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        keyboardManager.delegate = castedView
        castedView.sendButton.addTarget(self, action: #selector(sendRaport), for: .touchUpInside)
        castedView.closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        castedView.imagesContainer.delegate = self
        castedView.descriptionTextView.delegate = self

        initializeImages()
        updateReportButtonState()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardManager.turnOn()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardManager.turnOff()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        view.endEditing(true)
    }

    private func initializeImages() {
        let images = productImageManager.retrieveThumbnails(for: reason)
        castedView.imagesContainer.images = images
        imageCount = images.count
    }

    private func updateReportButtonState() {
        castedView.sendButton.isEnabled = imageCount > 0 || !castedView.descriptionTextView.text.isEmpty
    }

    @objc
    private func sendRaport() {
        view.endEditing(true)
        let imagePathArray = productImageManager.pathsForImages(for: reason)
        let report = Report(reason: reason,
                            description: castedView.descriptionTextView.text,
                            imagePaths: imagePathArray)
        KVNProgress.show(withStatus: R.string.localizable.sending())

        reportManager
            .send(report: report)
            .done { [weak self, reason, productImageManager, analytics] _ in
                KVNProgress.showSuccess(withStatus: R.string.localizable.reportSent())
                analytics.reportSent(barcode: reason.barcode)
                _ = productImageManager.removeImages(for: reason)
                self?.close()
            }.catch { error in
                BPLog("Error occured during sendind report: \(error.localizedDescription)")
                KVNProgress.showError(withStatus: R.string.localizable.errorOccured())
            }
    }

    @objc
    private func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension ReportProblemViewController: ReportImagesContainerViewDelegate {
    func imagesContainerTapDeleteButton(at index: Int) {
        guard productImageManager.removeImage(for: reason, index: index) else {
            BPLog("Error occured during removing image from report")
            KVNProgress.showError(withStatus: R.string.localizable.errorOccured())
            return
        }
        castedView.imagesContainer.removeImage(at: index)
        imageCount -= 1
        updateReportButtonState()
    }

    func imagesContainerTapAddButton() {
        let strings = R.string.localizable.self
        let alertVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alertVC.addAction(UIAlertAction(title: strings.takeAPhoto(),
                                            style: .default) { [weak self] _ in
                    self?.openImagePicker(source: .camera)
          })
        }
        alertVC.addAction(UIAlertAction(title: strings.chooseFromLibrary(),
                                        style: .default) { [weak self] _ in
                self?.openImagePicker(source: .photoLibrary)
        })
        alertVC.addAction(UIAlertAction(title: strings.cancel(), style: .cancel))
        present(alertVC, animated: true, completion: nil)
    }

    private func openImagePicker(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.modalPresentationStyle = .currentContext
        imagePicker.sourceType = source
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

extension ReportProblemViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.originalImage] as? UIImage,
            productImageManager.saveImage(image, for: reason, index: imageCount),
            let smallImage = productImageManager.retrieveThumbnail(for: reason, index: imageCount) else {
            BPLog("Error occured during obtaining image from image picker")
            KVNProgress.showError(withStatus: R.string.localizable.errorOccured())
            dismiss(animated: true, completion: nil)
            return
        }

        castedView.imagesContainer.addImage(smallImage)
        imageCount += 1
        updateReportButtonState()
        dismiss(animated: true, completion: nil)
    }
}

extension ReportProblemViewController: UITextViewDelegate {
    func textViewDidChange(_: UITextView) {
        updateReportButtonState()
    }
}

extension ReportProblemViewController: UINavigationControllerDelegate {}
