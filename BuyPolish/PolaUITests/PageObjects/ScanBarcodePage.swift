//
//  ScanCodePage.swift
//  PolaUITests
//
//  Created by Marcin Stepnowski on 11/04/2019.
//  Copyright © 2019 PJMS. All rights reserved.
//

import Foundation

class ScanBarcodePage : BasePage {
    
    func tapEnterBarcodeButton() -> EnterBarcodePage {
        app.buttons["Wpisz kod kreskowy"].tap()
        return EnterBarcodePage(app: app)
    }
    
    func tapInformationButton() -> InformationPage {
        app.buttons["Informacje o aplikacji"].tap()
        _ = app.staticTexts["OCEŃ NAS"].waitForExistence(timeout: 2)
        return InformationPage(app: app)
    }
}
