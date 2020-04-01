import Foundation

final class TimerBlock: NSObject {
    fileprivate let timer: Timer
    private let blockHandler: TimerBlockHandler
    
    init(timeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) {
        blockHandler = TimerBlockHandler(block)
        timer = Timer(timeInterval: interval,
                      target: blockHandler,
                      selector: #selector(callBlock(timer:)),
                      userInfo: nil,
                      repeats: true)
    }
    
    @objc
    func callBlock(timer: Timer) {
    }
    
    func invalidate() {
        timer.invalidate()
    }
}

final class TimerBlockHandler: NSObject {
    let block: (Timer) -> Void
    init(_ block: @escaping (Timer) -> Void) {
        self.block = block
        super.init()
    }
    
    @objc
    func callBlock(timer: Timer) {
        block(timer)
    }
}

extension RunLoop {
    func add(_ timer: TimerBlock, forMode mode: RunLoop.Mode) {
        add(timer.timer, forMode: mode)
    }
}
