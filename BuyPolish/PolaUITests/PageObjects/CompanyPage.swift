import Foundation

class CompanyPage: ScanBarcodePage {
    
    var isPolaFriend: Bool {
        return app.buttons["To jest przyjaciel Poli"].waitForExistence(timeout: 1)
    }
    
}
