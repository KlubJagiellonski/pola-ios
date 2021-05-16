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

    func test_shouldDetectBarcode_whenImageIsNotEmpty() {
        let validBarcodeImage = getImagePath()!
        let expectation = XCTestExpectation()
        var result: String?

        sut.getBarcodeFromImage(validBarcodeImage) { code in
            result = code
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
        XCTAssertEqual(result, barcode)
    }

    func test_shouldNotDetectBarcode_whenImageIsEmpty() {
        let expectation = XCTestExpectation()
        var result: String?

        sut.getBarcodeFromImage(UIImage()) { code in
            result = code
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
        XCTAssertNil(result)
    }
}
