import Alamofire

protocol DataRequestFactory {
    func request(path: String,
                 method: HTTPMethod,
                 parameters: Encodable?,
                 encoding: ParameterEncoding) -> DataRequest
}
