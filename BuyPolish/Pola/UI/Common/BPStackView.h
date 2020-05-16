#import <Foundation/Foundation.h>

@class BPStackView;
extern NSInteger const kBPStackViewDefaultCardCountLimit;

@protocol BPStackViewDelegate <NSObject>

- (void)stackView:(BPStackView *)stackView willAddCard:(UIView *)cardView;

- (void)stackView:(BPStackView *)stackView didRemoveCard:(UIView *)cardView;

- (void)stackView:(BPStackView *)stackView willExpandWithCard:(UIView *)cardView;

- (void)stackViewDidCollapse:(BPStackView *)stackView;

- (BOOL)stackView:(BPStackView *)stackView didTapCard:(UIView *)cardView;

@end

@protocol BPStackViewCardProtocol <NSObject>

- (void)setTitleHeight:(CGFloat)titleHeight;

- (void)setFocused:(BOOL)focused;

@end

@interface BPStackView : UIView

@property (weak, nonatomic) id<BPStackViewDelegate> delegate;
@property (nonatomic, readonly) NSInteger cardCount;
@property (nonatomic, readonly) CGFloat cardsHeight;

- (BOOL)addCard:(UIView *)cardView;

- (void)removeCard:(UIView *)cardView;

@end
