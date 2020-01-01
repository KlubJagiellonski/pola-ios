import Foundation

struct AboutRow {
    let title: String
    let analitycsName: AnalitycsAboutRow
    let action: Action
    
    enum Action {
        case link(String, Bool)
        case mail(String, String, String)
        case reportProblem
    }
}

typealias DoubleAboutRow = (AboutRow, AboutRow)
