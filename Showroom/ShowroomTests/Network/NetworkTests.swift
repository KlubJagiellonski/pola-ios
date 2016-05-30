import Quick
import Nimble
@testable import SHOWROOM

class NetworkTests: QuickSpec {
    override func spec() {
        describe("url by appending params") {
            context("when passing 1 param") {
                var url = NSURL(string: "http://test.com")!
                beforeEach {
                    url = url.URLByAppendingParams(["test": "param"])
                }
                it("correct url") {
                    expect(url.absoluteString) == "http://test.com?test=param"
                }
            }
            context("when passing more than 1 param") {
                var url = NSURL(string: "http://test.com")!
                beforeEach {
                    url = url.URLByAppendingParams(["test": "param", "test1": "param1"])
                }
                it("correct url") {
                    expect(url.absoluteString) == "http://test.com?test=param&test1=param1"
                }
            }
        }
    }
}
