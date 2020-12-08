import Foundation

protocol AnalyticsProvider {
    func configure()
    func logEvent(name: String, parameters: [String: String]?)
}
