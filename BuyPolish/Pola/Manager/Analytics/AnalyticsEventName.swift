import Foundation

enum AnalyticsEventName: String {
    case scanCode = "scan_code"
    case companyReceived = "company_received"
    case cardOpened = "card_opened"
    case reportStarted = "report_started"
    case reportFinished = "report_finished"
    case menuItemOpened = "menu_item_opened"
    case aipicsStarted = "aipics_started"
    case aipicsFinished = "aipics_finished"
}
