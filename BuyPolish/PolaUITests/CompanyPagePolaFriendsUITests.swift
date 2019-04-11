//
//  PolaFriendsUITests.swift
//  PolaUITests
//
//  Created by Marcin Stepnowski on 12/04/2019.
//  Copyright © 2019 PJMS. All rights reserved.
//

import XCTest

class CompanyPagePolaFriendsUITests: PolaUITestCase {
    
    func testGustawCompanyShouldBeMarkedAsPolaFriends() {
        let isPolaFriend =
        startingPageObject
            .tapEnterBarcodeButton()
            .inputBarcode("5904277719045")
            .tapOkButton()
            .waitForResultPageAndTap(companyName: "GUSTAW")
            .isPolaFriend
        
        XCTAssertTrue(isPolaFriend)
    }
    
    func testStaropramenCompanyShouldNotBeMarkedAsPolaFriends() {
        let isPolaFriend =
            startingPageObject
                .tapEnterBarcodeButton()
                .inputBarcode("8593868002832")
                .tapOkButton()
                .waitForResultPageAndTap(companyName: "Pivovary Staropramen")
                .isPolaFriend
        
        XCTAssertFalse(isPolaFriend)
    }

}
