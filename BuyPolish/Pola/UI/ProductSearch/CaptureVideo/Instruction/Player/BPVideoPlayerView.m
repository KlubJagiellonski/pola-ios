#import "BPVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface BPVideoPlayerView ()


@end

@implementation BPVideoPlayerView

- (instancetype)initWithframe:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = UIColor.clearColor;
        
    }
    
    return self;
}

- (void)playInLoopURL:(NSURL*)url {
    AVPlayer *player = [[AVPlayer alloc] initWithURL:url];
    self.playerLayer.player = player;
    
    player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
    
    // TODO: remove previous observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemDidReachEnd:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:[player currentItem]];

    [self.playerLayer.player play];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *p = [notification object];
    [p seekToTime:kCMTimeZero];
}

#pragma mark helper methods

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

@end
