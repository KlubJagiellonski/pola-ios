import Foundation

extension Double {
    func almostEqual(to other: Double) -> Bool {
        return abs(self - other) < 0.000001
    }
}