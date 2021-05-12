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
    let barcode = "5901696000457"

    override func setUp() {
        super.setUp()
        sut = BarcodeDetector()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    private func getImagePath(file: StaticString = #file) -> UIImage? {
        let fileUrl = URL(fileURLWithPath: "\(file)", isDirectory: false)
        let dirPath = fileUrl.deletingLastPathComponent()
        let imagePath = dirPath.appendingPathComponent("test_image.png")
        let imageData = try! Data(contentsOf: imagePath)
        return UIImage(data: imageData)
    }

    func test_imageDetected() {
        guard let validBarcodeImage = getImagePath() else {
            XCTFail("Image couldn't be read.")
            return
        }

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
