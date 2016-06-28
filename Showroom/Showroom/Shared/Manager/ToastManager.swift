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
        if toastWindow.animationInProgress || toastWindow.currentToastView != nil || timer != nil {
            messagesQueue.append(messages)
            return
        }
        
        toastWindow.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 0)
        toastWindow.showMessages(messages)
        toastWindow.hidden = false
        
        timer = NSTimer.scheduledTimerWithTimeInterval(toastVisibleTime, target: self, selector: #selector(ToastManager.onTimerAction), userInfo: nil, repeats: false)
    }
    
    private func hideMessages() {
        timer?.invalidate()
        timer = nil
        
        toastWindow.hideMessages { [weak self] in
            self?.showMessagesFromQueue()
        }
    }
    
    private func showMessagesFromQueue() {
        guard messagesQueue.count > 0 else {
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