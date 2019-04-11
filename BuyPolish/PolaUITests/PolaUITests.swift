//
//  PolaUITests.swift
//  PolaUITests
//
//  Created by Marcin Stepnowski on 11/04/2019.
//  Copyright © 2019 PJMS. All rights reserved.
//

import XCTest

class PolaUITestCase: XCTestCase {

    var startingPageObject: ScanBarcodePage!
    
    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
        startingPageObject = ScanBarcodePage(app: XCUIApplication())
    }
    
    override func tearDown() {
        startingPageObject = nil
    }

}
