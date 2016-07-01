import Quick
import Nimble
@testable import SHOWROOM

class ValidatorTests: QuickSpec {
    override func spec() {
        describe("validators") {
            context("empty validator") {
                let validator = NotEmptyValidator()
                
                it("should correctly validate") {
                    expect(validator.validate(nil)) == false
                    expect(validator.validate("")) == false
                    expect(validator.validate("test")) == true
                    expect(validator.validate("t")) == true
                }
            }
            
            context("phone number validator") {
                let validator = PhoneNumberValidator()
                
                it("should correctly validate") {
                    expect(validator.validate(nil)) == true
                    expect(validator.validate("")) == true
                    expect(validator.validate("+ test")) == true
                    expect(validator.validate("+")) == true
                    expect(validator.validate("test")) == false
                }
            }
        }
    }
}
