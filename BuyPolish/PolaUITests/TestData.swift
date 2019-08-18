//
//  TestData.swift
//  PolaUITests
//
//  Created by Marcin Stepnowski on 17/04/2019.
//  Copyright © 2019 PJMS. All rights reserved.
//

import Foundation

let ISBNCode: String = "9788328053045"

struct Company {
    let name: String
    let barcode: String
    
    static let Gustaw = Company(name: "GUSTAW", barcode: "5904277719045")
    static let Staropramen = Company(name: "Pivovary Staropramen", barcode: "8593868002832")
}
