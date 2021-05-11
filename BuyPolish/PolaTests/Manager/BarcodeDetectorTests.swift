//
//  BarcodeDetectorTests.swift
//  PolaTests
//
//  Created by Damian on 11/05/2021.
//  Copyright © 2021 PJMS. All rights reserved.
//

@testable import Pola
import XCTest

class BarcodeDetectorTests: XCTestCase {
    var sut: BarcodeDetector!
    let validBarcodeImage = UIImage(named: "test_image.png")!
    let barcode = "5901696000457"

    override func setUp() {
        super.setUp()
        sut = BarcodeDetector()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_imageDetected() {
        let expectation = XCTestExpectation()
        sut.getBarcodeFromImage(validBarcodeImage) { code in
            if code == self.barcode {
                expectation.fulfill()
            } else {
                XCTFail("Wrong barcode.")
            }
        }

        wait(for: [expectation], timeout: 10)
    }

    func test_imageNotDetected() {
        let expectation = XCTestExpectation()
        sut.getBarcodeFromImage(UIImage()) { code in
            if code == nil {
                expectation.fulfill()
            } else {
                XCTFail("Barcode should be nil.")
            }
        }

        wait(for: [expectation], timeout: 10)
    }
}
