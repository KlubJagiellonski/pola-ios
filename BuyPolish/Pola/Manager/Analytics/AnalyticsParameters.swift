import Foundation

protocol AnalyticsParameters: Encodable {}

struct AnalyticsScanCodeParameters: AnalyticsParameters {
    let code: String
    let device_id: String
    let source: String
}

struct AnalyticsProductResultParameters: AnalyticsParameters {
    let code: String?
    let company: String?
    let device_id: String
    let product_id: String?
}

struct AnalyticsReportParameters: AnalyticsParameters {
    let code: String
    let device_id: String
}

struct AnalyticsAboutParameters: AnalyticsParameters {
    let item: String
    let device_id: String
}

struct AnalitycsPolasFriendsParameters: AnalyticsParameters {
    let device_id: String
}
