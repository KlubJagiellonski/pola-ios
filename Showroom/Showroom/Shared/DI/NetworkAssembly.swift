import Foundation
import Swinject
import EmarsysPredictSDK

class NetworkAssembly: AssemblyType {
    func assemble(container: Container) {
        container.register(NetworkActivityIndicatorController.self) { r in
            return r.resolve(UIApplication.self)!
        }

        container.register(NSURLSession.self) { r in
            return NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        }

        container.register(NetworkClient.self) { r in
            return HttpClient(session: r.resolve(NSURLSession.self)!, activityIndicatorController: r.resolve(NetworkActivityIndicatorController.self)!)
        }.inObjectScope(.Container)

        container.register(ApiService.self) { r in
            return ApiService(networkClient: r.resolve(NetworkClient.self)!)
        }
        
        container.register(EmarsysService.self) { r in
            return EmarsysService(session: EMSession.sharedSession())
        }.inObjectScope(.Container)
    }
}

extension UIApplication: NetworkActivityIndicatorController { }