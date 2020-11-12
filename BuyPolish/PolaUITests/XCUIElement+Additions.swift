import XCTest

extension XCUIElement {
    func waitForDisappear(timeout: TimeInterval) -> Bool {
        let result = XCTWaiter().wait(for: [waitForDisappearExpectation()],
                                      timeout: timeout)
        return result == .completed
    }

    func waitForDisappearExpectation() -> XCTestExpectation {
        let predicate = NSPredicate(format: "exists == false")
        return XCTNSPredicateExpectation(predicate: predicate, object: self)
    }
}

extension Array where Element == XCUIElement {
    func waitForDisappear(timeout: TimeInterval) -> Bool {
        let expectations = map { $0.waitForDisappearExpectation() }
        let result = XCTWaiter().wait(for: expectations,
                                      timeout: timeout)
        return result == .completed
    }
}
