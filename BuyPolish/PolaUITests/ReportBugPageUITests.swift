//
//  ReportBugPageUITests.swift
//  PolaUITests
//
//  Created by Marcin Stepnowski on 27/04/2019.
//  Copyright © 2019 PJMS. All rights reserved.
//

import XCTest

class ReportBugPageUITests: PolaUITestCase {

    override func setUp() {
        super.setUp()
        recordMode = false
    }

    func testOpenReportBugPage() {
        startingPageObject
            .tapInformationButton()
            .tapReportBugButton()
            .done()
        
        snapshotVerifyView()
    }

}
