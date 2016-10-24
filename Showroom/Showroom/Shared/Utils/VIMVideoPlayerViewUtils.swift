import Foundation

extension VIMVideoPlayerView {
    var playbackTimeMillis: Int? {
        guard let currentSeconds = player.player.currentItem?.currentTime().seconds else {
            return nil
        }
        return Int(currentSeconds * Double(1000))
    }
    
    var playerItemDurationMillis: Int? {
        guard let durationSeconds = playerItemDurationSeconds else { return nil }
        return Int(durationSeconds * 1000)
    }
    
    var playerItemDurationSeconds: Double? {
        guard let cmTime = player.player.currentItem?.asset.duration else { return nil }
        return cmTime.seconds
    }
    
    func applyDefaultConfiguration() {
        player.looping = false
        player.disableAirplay()
    }
}
