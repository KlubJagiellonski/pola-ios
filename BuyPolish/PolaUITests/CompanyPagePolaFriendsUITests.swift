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
            goToCompanyPage(company: Company.Gustaw)
                .isPolaFriend
        
        XCTAssertTrue(isPolaFriend)
    }
    
    func testStaropramenCompanyShouldNotBeMarkedAsPolaFriends() {
        let isPolaFriend =
            goToCompanyPage(company: Company.Staropramen)
                .isPolaFriend
        
        XCTAssertFalse(isPolaFriend)
    }
    
    func goToCompanyPage(company: Company) -> CompanyPage {
        return startingPageObject
                .tapEnterBarcodeButton()
                .inputBarcode(company.barcode)
                .tapOkButton()
                .waitForResultPageAndTap(companyName: company.name)
    }

}
