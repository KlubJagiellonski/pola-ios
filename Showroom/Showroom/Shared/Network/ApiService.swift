import Foundation
import RxSwift

struct ApiService {
    let networkClient: NetworkClient
    
    var basePath: String {
        return Constants.baseUrl
    }
}

extension ApiService {
    func fetchContentPromo(withGender gender: Gender) -> Observable<[ContentPromo]> {
        let url = NSURL(fileURLWithPath: basePath)
            .URLByAppendingPathComponent("home")
            .URLByAppendingParams(["gender": gender.rawValue])
        
        let urlRequest = NSMutableURLRequest(URL: url)
        urlRequest.HTTPMethod = "GET"
        return networkClient
            .request(withRequest: urlRequest)
            .map {
                let array = try NSJSONSerialization.JSONObjectWithData($0, options: []) as! [AnyObject]
                return try array.map(ContentPromo.decode)
            }
    }
}

extension NSURL {
    func URLByAppendingParams(params: [String:String]) -> NSURL {
        var url = self.absoluteString
        url += "?"
        for (key, value) in params {
            url += key + "=" + value + "&"
        }
        url = url.substringToIndex(url.endIndex.predecessor())
        return NSURL(string: url)!
    }
}