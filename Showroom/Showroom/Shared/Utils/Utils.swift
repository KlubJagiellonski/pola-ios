import Foundation

enum FetchResult<T: Equatable> {
    case Success(T)
    case NetworkError(ErrorType)
}

enum FetchCacheResult<T: Equatable> {
    case Success(T)
    case CacheError(ErrorType)
    case NetworkError(ErrorType)
}

extension Array {
    func find(@noescape predicate: (Element) throws -> Bool) rethrows -> Element? {
        for element in self {
            if try predicate(element) {
                return element
            }
        }
        return nil
    }
}