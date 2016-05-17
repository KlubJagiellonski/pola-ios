import Foundation
import Swinject

class DiAssembler : Assembler {
    init() throws {
        try super.init(assemblies: [
            CoreAssembly(),
            NetworkAssembly(),
            UIAssembly()
            ])
    }
}
