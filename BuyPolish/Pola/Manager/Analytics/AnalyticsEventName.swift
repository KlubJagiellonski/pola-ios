import Foundation

enum AnalyticsEventName: String {
    case scanCode = "scan_code"
    case companyReceived = "company_received"
    case cardOpened = "card_opened"
    case readMore = "read_more"
    case reportStarted = "report_started"
    case reportFinished = "report_finished"
    case menuItemOpened = "menu_item_opened"
    case donateOpened = "donate_opened"
    case aboutPola = "about_pola"
    case polasFriends = "polas_friends"
    case openGallery = "open_gallery"
    case barcodeNotFoundOnPhoto = "barcode_not_found_on_photo"
    case mainTabChanged = "main_tab_changed"
}
