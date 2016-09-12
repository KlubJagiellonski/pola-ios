import UIKit

class ToastManager {
    private let toastVisibleTime: NSTimeInterval = 7.0
    private let toastWindow = ToastWindow()
    private var timer: NSTimer?
    private var currentMessageId = 0
    private var messagesQueue: [[String]] = []
    
    init() {
        toastWindow.backgroundColor = UIColor.clearColor()
        toastWindow.windowLevel = UIWindowLevelAlert
        toastWindow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ToastManager.onWindowTapped)))
    }
    
    func showMessage(message: String) {
        showMessages([message])
    }
    
    func showMessages(messages: [String]) {
        logInfo("Showing messages \(messages)")
        if toastWindow.animationInProgress || toastWindow.currentToastView != nil || timer != nil {
            logInfo("Adding to queue")
            messagesQueue.append(messages)
            return
        }
        
        toastWindow.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 0)
        toastWindow.showMessages(messages)
        toastWindow.hidden = false
        
        timer = NSTimer.scheduledTimerWithTimeInterval(toastVisibleTime, target: self, selector: #selector(ToastManager.onTimerAction), userInfo: nil, repeats: false)
    }
    
    private func hideMessages() {
        logInfo("Hide messages")
        timer?.invalidate()
        timer = nil
        
        toastWindow.hideMessages { [weak self] in
            self?.showMessagesFromQueue()
        }
    }
    
    private func showMessagesFromQueue() {
        logInfo("Show messages from queue")
        guard messagesQueue.count > 0 else {
            logInfo("No messages in queue, hidding window")
            toastWindow.hidden = true
            return
        }
        
        let messages = messagesQueue.removeAtIndex(0)
        showMessages(messages)
    }
    
    @objc func onTimerAction() {
        hideMessages()
    }
    
    @objc func onWindowTapped() {
        hideMessages()
    }
}