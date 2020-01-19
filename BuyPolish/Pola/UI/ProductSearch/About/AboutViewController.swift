import UIKit
import MessageUI

@objc
class AboutViewController: UITableViewController {
    
    enum Section: Int {
        case single
        case double
    }
    
    enum CellIdentifier: String {
        case single
        case double
    }
    
    private var model = AboutRowsFactory.create()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = R.string.localizable.info()
        let barItem =
            UIBarButtonItem(image: R.image.closeIcon(),
                            style: .plain,
                            target: self,
                            action: #selector(close))
        barItem.accessibilityLabel = R.string.localizable.accessibilityClose()
        navigationItem.rightBarButtonItem = barItem
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = Theme.mediumBackgroundColor
        tableView.register(AboutSingleCell.self, forCellReuseIdentifier: CellIdentifier.single.rawValue)
        tableView.register(AboutDoubleCell.self, forCellReuseIdentifier: CellIdentifier.double.rawValue)
        
        let headerHeight = CGFloat(8.0)
        let width = tableView.frame.width
        let header = UIView(frame: CGRect(origin: .zero,
                                          size: CGSize(width: width, height: headerHeight)))
        header.backgroundColor = Theme.mediumBackgroundColor
        tableView.tableHeaderView = header
        
        let footerHeight = CGFloat(70.0)
        tableView.tableFooterView =
            AboutFooterView(frame: CGRect(origin: .zero,
                                          size: CGSize(width: width, height: footerHeight)))
    }
    
    @objc
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .single:
            return model.rows.count
        case .double:
            return model.doubleRows.count
        default:
            return 0
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        49.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        switch Section(rawValue: indexPath.section) {
        case .single:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.single.rawValue, for: indexPath) as! AboutSingleCell
            cell.configure(rowInfo: model.rows[row])
            return cell
        case .double:
            let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.double.rawValue, for: indexPath) as! AboutDoubleCell
            cell.configure(rowInfo: model.doubleRows[row])
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(rawValue: indexPath.section) else {
            return
        }
        
        switch section {
        case .single:
            performAction(row: model.rows[indexPath.row])
        case .double:
            guard let cell = tableView.cellForRow(at: indexPath) as? AboutDoubleCell,
                cell.selectedSegment != .none else {
                break
            }
            let doubleRow = model.doubleRows[indexPath.row]
            let row = cell.selectedSegment == .first ? doubleRow.0 : doubleRow.1
            performAction(row: row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Private
    
    private func performAction(row: AboutRow) {
        AnalyticsHelper.aboutOpenedd(windowName: row.analitycsName)
        switch row.action {
        case .link(let url, let openInternal):
            performLinkAction(title: row.title, url: url, openInternal: openInternal)
        case .mail(let mailAddress, let title, let message):
            performMailAction(mailAddress: mailAddress, title: title, message: message)
        case .reportProblem:
            performReportProblemAction()
        }
    }
    
    private func performLinkAction(title: String, url: String, openInternal: Bool) {
        if openInternal {
            let vc = AboutWebViewController(url: url, title: title)
            navigationController?.pushViewController(vc, animated: true)
        } else {
            if let url = URL(string: url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    private func performMailAction(mailAddress: String, title: String, message: String) {
        let composeViewController = MFMailComposeViewController()
        composeViewController.mailComposeDelegate = self
        composeViewController.setToRecipients([mailAddress])
        composeViewController.setSubject(title)
        composeViewController.setMessageBody(message, isHTML: false)
        present(composeViewController, animated: true, completion: nil)
    }
    
    private func performReportProblemAction() {
        let vc = DI.container.resolve(ReportProblemViewController.self, argument:RaportProblemReason.general)!
        present(vc, animated: true, completion: nil)
    }
}

extension AboutViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
}
