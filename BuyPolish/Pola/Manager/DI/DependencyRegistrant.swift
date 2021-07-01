import Swinject

protocol DependencyRegistrant {
    func registerDependency(container: Container)
}
