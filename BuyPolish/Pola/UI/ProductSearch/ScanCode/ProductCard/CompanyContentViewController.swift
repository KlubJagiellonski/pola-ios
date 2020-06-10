import UIKit

final class CompanyContentViewController: UIViewController {
    let result: ScanResult

    init(result: ScanResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = CompanyContentView()
    }

    override func viewDidLoad() {
        let companyView = view as! CompanyContentView

        companyView.friendButton.addTarget(self, action: #selector(friendTapped), for: .touchUpInside)
        if let plCapital = result.plCapital {
            companyView.capitalProgressView.progress = CGFloat(plCapital) / 100.0
        } else {
            companyView.capitalProgressView.progress = nil
        }
        companyView.notGlobalCheckRow.checked = bool(from: result.plNotGlobEnt)
        companyView.workersCheckRow.checked = bool(from: result.plWorkers)
        companyView.registeredCheckRow.checked = bool(from: result.plRegistered)
        companyView.rndCheckRow.checked = bool(from: result.plRnD)
        companyView.descriptionLabel.text = result.description
        companyView.friendButton.isHidden = !(result.isFriend ?? false)

        switch result.cardType {
        case .grey:
            companyView.capitalProgressView.fillColor = Theme.strongBackgroundColor
            companyView.capitalProgressView.percentColor = Theme.clearColor

        case .white:
            companyView.capitalProgressView.fillColor = Theme.lightBackgroundColor
            companyView.capitalProgressView.percentColor = Theme.defaultTextColor
        }
    }

    @objc
    private func friendTapped() {
        let webViewController = AboutWebViewController(url: "https://www.pola-app.pl/m/friends",
                                                       title: R.string.localizable.polaSFriends())
        let closeButtonItem =
            UIBarButtonItem(image: R.image.closeIcon(), style: .plain, target: self, action: #selector(closeWebViewTapped))
        closeButtonItem.accessibilityLabel = R.string.localizable.accessibilityClose()
        webViewController.navigationItem.rightBarButtonItem = closeButtonItem
        let navigationController = UINavigationController(rootViewController: webViewController)
        present(navigationController, animated: true, completion: nil)
    }

    @objc
    private func closeWebViewTapped() {
        dismiss(animated: true, completion: nil)
    }

    private func bool(from int: Int?) -> Bool? {
        guard let int = int else {
            return nil
        }
        return int != 0
    }
}
