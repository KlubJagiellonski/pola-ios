@import UIKit;

@class BPImageContainerView;

@protocol BPImageContainerViewDelegate <NSObject>
- (void)didTapAddImage:(BPImageContainerView *)imageContainerView;

- (void)didTapRemoveImage:(BPImageContainerView *)imageContainerView atIndex:(int)index;
@end

@interface BPImageContainerView : UIView

@property (weak, nonatomic) id<BPImageContainerViewDelegate> delegate;

- (void)addImage:(UIImage *)image;

- (void)removeImageAtIndex:(int)index;

@end
