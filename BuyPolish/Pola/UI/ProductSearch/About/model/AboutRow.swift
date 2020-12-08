import Foundation

struct AboutRow {
    let title: String
    let analyticsName: AnalyticsAboutRow
    let action: Action

    enum Action {
        case link(String, Bool)
        case mail(String, String, String)
        case reportProblem
    }
}

typealias DoubleAboutRow = (AboutRow, AboutRow)
