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
    func find(@noescape predicate: (Element) -> Bool) -> Element? {
        for element in self {
            if predicate(element) {
                return element
            }
        }
        return nil
    }
}