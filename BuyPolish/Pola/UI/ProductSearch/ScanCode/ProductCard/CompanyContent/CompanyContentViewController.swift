import PromiseKit
import UIKit

final class CompanyContentViewController: UIViewController {
    private let result: ScanResult
    private let logoHeight = CGFloat(100.0)

    private var companyView: CompanyContentView! {
        view as? CompanyContentView
    }

    init(result: ScanResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = CompanyContentView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

        if let logotypeUrl = company.logotypeUrl {
            UIImage.load(url: logotypeUrl)
                .map { $0?.scaled(toHeight: 100.0) }
                .done(on: .main) { [weak self] image in
                    self?.logotypeLoaded(image)
                }
                .catch { error in
                    BPLog("Error loading company logotype: \(error)")
                }
        } else {
            companyView.logotypeButton.isHidden = true
        }

        companyView.brandLogotypesView.brands = result.allCompanyBrands
        if company.officialUrl != nil {
            companyView.readMoreButton.isHidden = false
            companyView.readMoreButton.addTarget(self, action: #selector(logotypeTapped), for: .touchUpInside)
        }

        view.setNeedsLayout()
    }

    private func logotypeLoaded(_ image: UIImage?) {
        guard let image else { return }

        companyView.logotypeButton.setImage(image, for: .normal)
        companyView.logotypeButton.isHidden = false

        let company = result.companies?.first
        let companyName = company?.name ?? ""
        let strings = R.string.localizable.self

        companyView.logotypeButton.accessibilityLabel = strings.accessibilityCompanyLogotype(companyName)
        companyView.logotypeButton.accessibilityTraits.insert(.image)

        if company?.officialUrl != nil {
            companyView.logotypeButton.addTarget(self, action: #selector(logotypeTapped), for: .touchUpInside)
            companyView.logotypeButton.isUserInteractionEnabled = true
            companyView.logotypeButton.accessibilityTraits.insert(.button)
            companyView.logotypeButton.accessibilityHint = strings.accessibilityCompanyLogotypeHint()
        } else {
            companyView.logotypeButton.isUserInteractionEnabled = false
            companyView.logotypeButton.accessibilityTraits.remove(.button)
        }
    }

    @objc
    private func logotypeTapped() {
        guard let officialUrl = result.companies?.first?.officialUrl
        else { return }

        UIApplication.shared.open(officialUrl)
    }

    @objc
    private func friendTapped() {
        let webViewController = WebViewController(url: "https://www.pola-app.pl/m/friends",
                                                  title: R.string.localizable.polaSFriends())
        webViewController.addCloseButton()
        let navigationController = UINavigationController.makeForWebView(rootViewController: webViewController)
        present(navigationController, animated: true, completion: nil)
    }

    private func bool(from int: Int?) -> Bool? {
        guard let int = int else {
            return nil
        }
        return int != 0
    }
}
