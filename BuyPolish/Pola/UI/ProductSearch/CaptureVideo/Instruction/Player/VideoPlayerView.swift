import UIKit
import AVFoundation

@objc(BPVideoPlayerView)
class VideoPlayerView: UIView {
    
    @objc(playInLoopURL:)
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
    
    @objc
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
