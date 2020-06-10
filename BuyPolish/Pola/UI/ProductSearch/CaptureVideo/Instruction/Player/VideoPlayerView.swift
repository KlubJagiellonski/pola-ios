import AVFoundation
import UIKit

final class VideoPlayerView: UIView {
    func playInLoop(url: URL) {
        let player = AVPlayer(url: url)
        player.isMuted = true
        playerLayer.player = player
        player.actionAtItemEnd = .none

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { notification in
            guard let playerItem = notification.object as? AVPlayerItem else {
                return
            }
            playerItem.seek(to: .zero)
        }

        player.play()
    }

    func stop() {
        playerLayer.player?.pause()
    }

    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    private var playerLayer: AVPlayerLayer {
        layer as! AVPlayerLayer
    }
}
