//
//  EnterBarcodePage.swift
//  PolaUITests
//
//  Created by Marcin Stepnowski on 11/04/2019.
//  Copyright © 2019 PJMS. All rights reserved.
//

import XCTest

class EnterBarcodePage: BasePage {
    
    func tapEnterBarcodeButton() -> ScanBarcodePage {
        app.buttons["Wpisz kod kreskowy"].tap()
        return ScanBarcodePage(app: app)
    }
    
    func tapOkButton() -> EnterBarcodePage {
        app.buttons["Zatwierdź"].tap()
        return self
    }
    
    func tapDeleteButton() -> EnterBarcodePage {
        app.buttons["Usuń ostatnią cyfrę"].tap()
        return self
    }
    
    func inputBarcode(_ barcode: String) -> EnterBarcodePage {
        barcode.forEach { character in
            app.buttons[String(character)].tap()
        }
        return self
    }

    func waitForResultPageAndTap(companyName: String) -> CompanyPage {
        app.otherElements[companyName].tap()
        return CompanyPage(app: app)
    }
    
    func waitForResultPage(companyName: String) -> ScanBarcodeWithResultsPage {
        if !app.otherElements[companyName].waitForExistence(timeout: 3) {
            XCTFail("No matches found for scan result:  \(companyName)")
        }
        return ScanBarcodeWithResultsPage(app: app)
    }
    
}