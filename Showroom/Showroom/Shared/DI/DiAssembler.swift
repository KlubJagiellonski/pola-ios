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
    
    func resolve<Service, Arg1, Arg2>(serviceType: Service.Type, arguments: (Arg1, Arg2)) -> Service {
        return resolvable.resolve(serviceType, arguments: arguments)!
    }
    
    func resolve<Service, Arg1, Arg2, Arg3>(serviceType: Service.Type, arguments: (Arg1, Arg2, Arg3)) -> Service {
        return resolvable.resolve(serviceType, arguments: arguments)!
    }
    
    func resolve<Service, Arg1, Arg2, Arg3, Arg4>(serviceType: Service.Type, arguments: (Arg1, Arg2, Arg3, Arg4)) -> Service {
        return resolvable.resolve(serviceType, arguments: arguments)!
    }
}