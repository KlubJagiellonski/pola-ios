import Foundation
import Swinject

class DiAssembler: Assembler {
    init() throws {
        try super.init(assemblies: [
            CoreAssembly(),
            NetworkAssembly(),
            UIAssembly()
        ])
    }
}

protocol ResolverContainer {
    var resolver: Resolvable? { get }
}

extension ResolverContainer {
    var resolver: Resolvable? {
        return SwinjectStoryboard.defaultContainer
    }
}

extension UIViewController: ResolverContainer {
    
}