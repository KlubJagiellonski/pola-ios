import Foundation
import Swinject
import EmarsysPredictSDK

class NetworkAssembly: AssemblyType {
    func assemble(container: Container) {
        container.register(NetworkActivityIndicatorController.self) { r in
            return r.resolve(UIApplication.self)!
        }
        
        container.register(NetworkClient.self) { r in
            return HttpClient(activityIndicatorController: r.resolve(NetworkActivityIndicatorController.self)!)
        }.inObjectScope(.Container)
        
        container.register(ApiService.self) { r in
            return ApiService(networkClient: r.resolve(NetworkClient.self)!)
        }.inObjectScope(.Container)
        
        container.register(EmarsysService.self) { r in
            return EmarsysService(session: EMSession.sharedSession())
        }.inObjectScope(.Container)
    }
}

extension UIApplication: NetworkActivityIndicatorController { }