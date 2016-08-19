import Foundation
import UIKit

typealias ObjectId = Int

enum FetchCacheResult<T: Equatable> {
    case Success(T)
    case CacheError(ErrorType)
    case NetworkError(ErrorType)
    
    func result() -> T? {
        switch self {
        case .Success(let result): return result
        default: return nil
        }
    }
}

extension FetchCacheResult: Equatable {}

func ==<T: Equatable>(lhs: FetchCacheResult<T>, rhs: FetchCacheResult<T>) -> Bool {
    if case let FetchCacheResult.Success(lhsResult) = lhs {
        if case let FetchCacheResult.Success(rhsResult) = rhs {
            return lhsResult == rhsResult
        }
    }
    return false
}

extension Array {
    func find(@noescape predicate: (Element) -> Bool) -> Element? {
        for element in self {
            if predicate(element) {
                return element
            }
        }
        return nil
    }
    
    func createIndexes(@noescape retrieveName: (Element) -> String) -> [String: [Element]] {
        var index: [String: [Element]] = [:]
        
        let letters = NSCharacterSet.letterCharacterSet()
        
        for item in self {
            let name = retrieveName(item)
            if name.characters.count == 0 {
                continue
            }
            var indexLetter = String(name.characters.first!).uppercaseString
            if !letters.longCharacterIsMember(indexLetter.unicodeScalars.first!.value) {
                indexLetter = "#"
            }
            if index.keys.contains(indexLetter) {
                index[indexLetter]?.append(item)
            } else {
                index[indexLetter] = [item]
            }
        }
        
        return index
    }
}

func ==<T: Equatable>(lhs: [T]?, rhs: [T]?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?) :
        return l == r
    case (.None, .None):
        return true
    default:
        return false
    }
}

class MoneyFormatter: NSNumberFormatter {
    override init() {
        super.init()
        
        locale = NSLocale.currentLocale()
        numberStyle = NSNumberFormatterStyle.DecimalStyle
        usesGroupingSeparator = true
        alwaysShowsDecimalSeparator = true
        maximumFractionDigits = 2
        minimumFractionDigits = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionType {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension Array {
    mutating func remove(predicate: (Element) -> Bool) {
        guard let index = self.indexOf(predicate) else {
            return
        }
        self.removeAtIndex(index)
    }
}

extension NSURL {
    func changeToHTTPSchemeIfNeeded() -> NSURL? {
        let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: true)
        if components?.scheme != "https" {
            components?.scheme = "https"
        }
        return components?.URL
    }
}

extension CALayer {
    static func performWithoutAnimation(@noescape block: Void -> Void) {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        block()
        CATransaction.commit()
    }
}

// MARK: - UIEdgeInsets operators

func +(left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsetsMake(left.top + right.top, left.left + right.left, left.bottom + right.bottom, left.right + right.right)
}

func -(left: UIEdgeInsets, right: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsetsMake(left.top - right.top, left.left - right.left, left.bottom - right.bottom, left.right - right.right)
}