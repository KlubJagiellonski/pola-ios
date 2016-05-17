import Foundation
import Swinject

class CoreAssembly: AssemblyType {
    func assemble(container: Container) {
        container.register(UIApplication.self) { r in
            return UIApplication.sharedApplication()
        }
    }
}