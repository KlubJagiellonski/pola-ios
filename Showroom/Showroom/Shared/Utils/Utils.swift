import Foundation

enum FetchResult<T: Equatable> {
    case Success(T)
    case NetworkError(ErrorType)
    
    func result() -> T? {
        switch self {
        case .Success(let result): return result
        default: return nil
        }
    }
}

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

func ==<T: Equatable>(lhs: FetchCacheResult<T>, rhs: FetchCacheResult<T>) -> Bool
{
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
}