import Alamofire

final class PolaRequestFactory: DataRequestFactory {
    let processInfo: ProcessInfo
    let device: UIDevice

    init(processInfo: ProcessInfo, device: UIDevice) {
        self.processInfo = processInfo
        self.device = device
    }

    private var baseURL: String {
        processInfo.environment["POLA_URL"] ?? "https://www.pola-app.pl/a/v4"
    }

    func request(path: String,
                 method: HTTPMethod,
                 parameters: Encodable?,
                 encoding: ParameterEncoding) -> DataRequest {
        Alamofire.request("\(baseURL)/\(path)?device_id=\(device.deviceId)",
                          method: method,
                          parameters: parameters?.dictionary,
                          encoding: encoding,
                          headers: nil)
    }
}
