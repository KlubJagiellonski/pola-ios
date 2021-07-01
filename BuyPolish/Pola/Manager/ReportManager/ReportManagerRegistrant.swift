import Foundation
import Swinject

final class ReportManagerRegistrant: DependencyRegistrant {
    func registerDependency(container: Container) {
        container.register(ReportManager.self) { resolver in
            PolaReportManager(dataRequestFactory: resolver.resolve(DataRequestFactory.self)!,
                              uploadMediaRequestFactory: resolver.resolve(MediaUploadRequestFactory.self)!,
                              fileManager: resolver.resolve(FileManager.self)!)
        }
    }
}
