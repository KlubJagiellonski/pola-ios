import Foundation

extension VIMVideoPlayerView {
    var playbackDurationMillis: Int? {
        guard let durationSeconds = playbackDurationSeconds else { return nil }
        return Int(durationSeconds * 1000)
    }
    
    var playbackDurationSeconds: Double? {
        guard let cmTime = player.player.currentItem?.asset.duration else { return nil }
        return cmTime.seconds
    }
    
    func applyDefaultConfiguration() {
        player.looping = false
        player.disableAirplay()
    }
}