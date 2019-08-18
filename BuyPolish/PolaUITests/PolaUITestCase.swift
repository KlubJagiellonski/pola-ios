//
//  PolaUITests.swift
//  PolaUITests
//
//  Created by Marcin Stepnowski on 11/04/2019.
//  Copyright © 2019 PJMS. All rights reserved.
//

import XCTest
import FBSnapshotTestCase

class PolaUITestCase: FBSnapshotTestCase {

    var startingPageObject: ScanBarcodePage!
    private var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["--disableAnimations"]
        app.launch()
        startingPageObject = ScanBarcodePage(app: app)
    }
    
    override func tearDown() {
        startingPageObject = nil
        app = nil
        super.tearDown()
    }
    
    func snapshotVerifyView(file: StaticString = #file, line: UInt = #line) {
        let fullscreen = app.screenshot().image
        FBSnapshotVerifyView(UIImageView(image: fullscreen), file: file, line: line)
    }
    
    override func recordFailure(
        withDescription description: String,
        inFile filePath: String,
        atLine lineNumber: Int,
        expected: Bool
        ) {
        
        let imageData = app.screenshot().image.pngData()
        if let path = failureImageDirectoryPath?
            .appendingPathComponent("/")
            .appendingPathComponent("\(self)_\(lineNumber)")
            .appendingPathComponent(".png"){
            
            try? imageData?.write(to: path)
        }
        
        super.recordFailure(withDescription: description, inFile: filePath, atLine: lineNumber, expected: expected)
    }
    
    private var failureImageDirectoryPath: URL? {
        let fileManager = FileManager.default
        guard let pathString = ProcessInfo.processInfo.environment["FAILED_UI_TEST_DIR"] else {
            return nil
        }
        
        let path = URL(fileURLWithPath: pathString)
        if !fileManager.fileExists(atPath: path.absoluteString) {
            try? fileManager.createDirectory(
                at: path,
                withIntermediateDirectories: true,
                attributes: nil
            )
        }
        return path
    }

}
