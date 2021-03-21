import UIKit

class OwnBrandContentViewController: UIViewController {
    let result: ScanResult
    private var ownBrandView: OwnBrandContentView! {
        view as? OwnBrandContentView
    }

    init(result: ScanResult) {
        self.result = result
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = OwnBrandContentView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let companies = result.companies,
            companies.count == 2 else {
            return
        }

        setupCompanyTitleView(ownBrandView.primaryCompanyTitleView, company: companies[0])
        setupCompanyTitleView(ownBrandView.secondaryCompanyTitleView, company: companies[1])

        ownBrandView.descriptionView.text =
            R.string.localizable.ownBrandDescription(companies[1].name, companies[0].name)
    }

    private func setupCompanyTitleView(_ titleView: OwnBrandCompanyTitleView, company: Company) {
        titleView.title = company.name
        if let score = company.plScore {
            titleView.progress = CGFloat(score) / 100.0
        } else {
            titleView.progress = 0
        }
    }
}
