import Foundation

class CompanyPage: ResultPage {
    
    var isPolaFriend: Bool {
        return app.buttons["To jest przyjaciel Poli"].waitForExistence(timeout: 1)
    }
    
}
