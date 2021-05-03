import Foundation

extension ScanResult {
    var isFriend: Bool {
        guard let companies = companies,
            !companies.isEmpty else {
            return false
        }
        return companies.allSatisfy { $0.isFriend ?? false }
    }

    var isNotFriend: Bool {
        !isFriend
    }
}
