import XCTest
@testable import Pola

class UIColor_AdditionsTests: XCTestCase {
    
    func testInit(red: Int = 0, green: Int = 0, blue: Int = 0, expected: UIColor, file: StaticString = #file, line: UInt = #line) {
        // Act
        let color = UIColor(red: red, green: green, blue: blue)
        
        // Act
        XCTAssertEqual(color, expected, file: file, line: line)
    }

    func testInitWithRedGreenBlueInts_WhenR0_G0_B0() {
        testInit(expected: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func testInitWithRedGreenBlueInts_WhenR51_G0_B0() {
        testInit(red: 51, expected: UIColor(red: 0.2, green: 0, blue: 0, alpha: 1))
    }
    
    func testInitWithRedGreenBlueInts_WhenR255_G0_B0() {
        testInit(red: 255, expected: UIColor(red: 1, green: 0, blue: 0, alpha: 1))
    }
    
    func testInitWithRedGreenBlueInts_WhenR0_G51_B0() {
        testInit(green: 51, expected: UIColor(red: 0, green: 0.2, blue: 0, alpha: 1))
    }
    
    func testInitWithRedGreenBlueInts_WhenR0_G255_B0() {
        testInit(green: 255, expected: UIColor(red: 0, green: 1, blue: 0, alpha: 1))
    }
    
    func testInitWithRedGreenBlueInts_WhenR0_G0_B51() {
        testInit(blue: 51, expected: UIColor(red: 0, green: 0, blue: 0.2, alpha: 1))
    }
    
    func testInitWithRedGreenBlueInts_WhenR0_G0_B255() {
        testInit(blue: 255, expected: UIColor(red: 0, green: 0, blue: 1, alpha: 1))
    }
    
    func testInit(rgb: Int, expected: UIColor, file: StaticString = #file, line: UInt = #line) {
        // Act
        let color = UIColor(rgb: rgb)
        
        // Act
        XCTAssertEqual(color, expected, file: file, line: line)
    }
    
    func testInitWithRGB_WhenRGB000000(){
        testInit(rgb: 0x000000, expected: UIColor(red: 0, green: 0, blue: 0, alpha: 1))
    }
    
    func testInitWithRGB_WhenRGB0xCC0000(){
        testInit(rgb: 0xCC0000, expected: UIColor(red: 0.8, green: 0, blue: 0, alpha: 1))
    }

    func testInitWithRGB_WhenRGB0xFF0000(){
        testInit(rgb: 0xFF0000, expected: UIColor(red: 1, green: 0, blue: 0, alpha: 1))
    }
    
    func testInitWithRGB_WhenRGB0x00CC00(){
        testInit(rgb: 0x00CC00, expected: UIColor(red: 0, green: 0.8, blue: 0, alpha: 1))
    }
    
    func testInitWithRGB_WhenRGB0x00FF00(){
        testInit(rgb: 0x00FF00, expected: UIColor(red: 0, green: 1, blue: 0, alpha: 1))
    }

    func testInitWithRGB_WhenRGB0x0000CC(){
        testInit(rgb: 0x0000CC, expected: UIColor(red: 0, green: 0, blue: 0.8, alpha: 1))
    }
    
    func testInitWithRGB_WhenRGB0x0000FF(){
        testInit(rgb: 0x0000FF, expected: UIColor(red: 0, green: 0, blue: 1, alpha: 1))
    }

}
