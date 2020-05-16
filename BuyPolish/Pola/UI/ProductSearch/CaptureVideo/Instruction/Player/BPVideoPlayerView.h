#import <Foundation/Foundation.h>

@class BPVideoPlayerView;

@interface BPVideoPlayerView : UIView

- (void)playInLoopURL:(NSURL *)URL;
- (void)stop;

@end
