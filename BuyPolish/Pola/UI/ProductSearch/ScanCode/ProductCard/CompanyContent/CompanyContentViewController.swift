import UIKit

final class CompanyContentViewController: UIViewController {
    let result: ScanResult
    private var companyView: CompanyContentView! {
        view as? CompanyContentView
    }

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
        guard let company = result.companies?.first else {
            return
        }
        companyView.friendButton.addTarget(self, action: #selector(friendTapped), for: .touchUpInside)
        if let plCapital = company.plCapital {
            companyView.capitalProgressView.progress = CGFloat(plCapital) / 100.0
        } else {
            companyView.capitalProgressView.progress = nil
        }
        companyView.notGlobalCheckRow.checked = bool(from: company.plNotGlobEnt)
        companyView.workersCheckRow.checked = bool(from: company.plWorkers)
        companyView.registeredCheckRow.checked = bool(from: company.plRegistered)
        companyView.rndCheckRow.checked = bool(from: company.plRnD)
        companyView.descriptionLabel.text = company.description
        companyView.friendButton.isHidden = !(company.isFriend ?? false)

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
        webViewController.addCloseButton()
        let navigationController = UINavigationController(rootViewController: webViewController)
        present(navigationController, animated: true, completion: nil)
    }

    private func bool(from int: Int?) -> Bool? {
        guard let int = int else {
            return nil
        }
        return int != 0
    }
}
