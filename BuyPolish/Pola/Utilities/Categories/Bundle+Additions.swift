import Foundation

extension Bundle {
    var version: String! {
        infoDictionary?["CFBundleVersion"] as? String
    }

    var shortVersion: String! {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
