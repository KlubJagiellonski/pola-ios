import Quick
import Nimble
@testable import SHOWROOM

class NavigationTests: QuickSpec {
    override func spec() {
        let rootVC = RootTestVC()
        let leafVC = rootVC.childViewControllers.first as! LeafTestVC
        let subLeafVC = leafVC.childViewControllers.first as! SubLeafTestVC
        
        describe("send navigation event") {
            context("when sending first") {
                beforeEach {
                    subLeafVC.sendNavigationEvent(FirstNavigationEvent())
                }
                it("SubLeafVC handles") {
                    expect(subLeafVC.handled) == true
                    expect(leafVC.handled) == false
                    expect(rootVC.handled) == false
                }
            }
            context("when sending second") {
                beforeEach {
                    subLeafVC.sendNavigationEvent(SecondNavigationEvent())
                }
                it("LeafVC handles") {
                    expect(subLeafVC.handled) == false
                    expect(leafVC.handled) == true
                    expect(rootVC.handled) == false
                }
            }
            context("when sending third") {
                beforeEach {
                    subLeafVC.sendNavigationEvent(ThirdNavigationEvent())
                }
                it("Root handles") {
                    expect(subLeafVC.handled) == false
                    expect(leafVC.handled) == false
                    expect(rootVC.handled) == true
                }
            }
            context("when sending fourth") {
                var handled = true
                beforeEach {
                    handled = subLeafVC.sendNavigationEvent(FourthNavigationEvent())
                }
                it("No one handles") {
                    expect(subLeafVC.handled) == false
                    expect(leafVC.handled) == false
                    expect(rootVC.handled) == false
                    expect(handled) == false
                }
            }
        }
    }
}

struct FirstNavigationEvent : NavigationEvent { }
struct SecondNavigationEvent : NavigationEvent { }
struct ThirdNavigationEvent : NavigationEvent { }
struct FourthNavigationEvent : NavigationEvent { }

class RootTestVC : UIViewController, NavigationHandler {
    init() {
        super.init(nibName: nil, bundle: nil)
        addChildViewController(LeafTestVC())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var handled = false
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        handled = event is ThirdNavigationEvent
        return handled
    }
}

class LeafTestVC : UIViewController, NavigationHandler {
    init() {
        super.init(nibName: nil, bundle: nil)
        addChildViewController(SubLeafTestVC())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var handled = false
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        handled = event is SecondNavigationEvent
        return handled
    }
}

class SubLeafTestVC : UIViewController, NavigationHandler {
    var handled = false
    func handleNavigationEvent(event: NavigationEvent) -> EventHandled {
        handled = event is FirstNavigationEvent
        return handled
    }
}