import Foundation
@testable import Pola

extension CodeData {
    var scanResult: ScanResult {
        let path = Bundle(for: LaunchScreenSnapshotTests.self)
            .path(forResource: responseFile, ofType: "json")!
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        let result = try! JSONDecoder().decode(ScanResult.self, from: data)
        return result
    }
}
