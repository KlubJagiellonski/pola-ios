import Foundation

protocol DeepLinkingHandler {
    func handleOpen(withURL url: NSURL) -> Bool
}
