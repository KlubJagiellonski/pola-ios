import XCTest
@testable import Pola

final class Encodable_DictionaryTests: XCTestCase {

    private struct TestObject: Encodable {
        let question: String?
        let answer: Int?
    }

    private struct TestObjectWithObject: Encodable {
        let object: TestObject
    }

    func testDictionary_shouldReturnEmptyDictionary_WhenPropertiesAreNil() {
        // Arrange
        let sut = TestObject(question: nil, answer: nil)

        // Act
        let dict = sut.dictionary

        // Assert
        XCTAssertEqual(dict?.count, 0)
    }

    func testDictionary_WhenPropertiesAreNotNil() {
        // Arrange
        let expectedQuestion = "What is the answer to life the universe and everything?"
        let expectedAnswer = 42
        let sut = TestObject(question: expectedQuestion, answer: expectedAnswer)

        // Act
        let dict = sut.dictionary

        // Assert
        XCTAssertEqual(dict?.count, 2)
        XCTAssertEqual(dict?["question"] as! String, expectedQuestion)
        XCTAssertEqual(dict?["answer"] as! Int, expectedAnswer)
    }

    func testDictionary_WhenEncodableIsNested() {
        // Arrange
        let sut = TestObjectWithObject(object: TestObject(question: "?", answer: 1))

        // Act
        let dict = sut.dictionary

        // Assert
        XCTAssertEqual(dict?.count, 1)
        let nestedDict = dict?["object"] as! [String: Any]
        XCTAssertEqual(nestedDict.count, 2)
    }

}
