import Foundation
import Swinject

class DiAssembler: Assembler {
    init() throws {
        try super.init(assemblies: [
            CoreAssembly(),
            NetworkAssembly(),
            UIAssembly(),
            ManagerAssembly()
        ])
    }
}

struct DiResolver {
    let resolvable: Resolvable
    
    func resolve<Service>(serviceType: Service.Type) -> Service {
        return resolvable.resolve(serviceType)!
    }
    
    func resolve<Service, Arg1>(serviceType: Service.Type, argument: Arg1) -> Service {
        return resolvable.resolve(serviceType, argument: argument)!
    }
}