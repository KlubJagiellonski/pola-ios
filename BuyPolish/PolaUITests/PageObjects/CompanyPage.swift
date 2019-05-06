//
//  CompanyPage.swift
//  PolaUITests
//
//  Created by Marcin Stepnowski on 12/04/2019.
//  Copyright © 2019 PJMS. All rights reserved.
//

import Foundation

class CompanyPage: ScanBarcodePage {
    
    var isPolaFriend: Bool {
        return app.buttons["To jest przyjaciel Poli"].waitForExistence(timeout: 1)
    }
    
}
