//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPProductCardView;
@protocol BPCardViewProtocol;


@protocol BPStackViewDelegate <NSObject>

- (void)willAddCard:(UIView<BPCardViewProtocol> *)cardView withAnimationDuration:(CGFloat)animationDuration;

- (void)willEnterFullScreen:(UIView<BPCardViewProtocol> *)cardView withAnimationDuration:(CGFloat)animationDuration;

- (void)didExitFullScreen:(UIView<BPCardViewProtocol> *)cardView;
@end


@interface BPStackView : UIScrollView <UIGestureRecognizerDelegate>

@property(nonatomic, weak) id <BPStackViewDelegate> stackDelegate;
@property(nonatomic, readonly) NSInteger cardCount;

- (BOOL)addCard:(UIView<BPCardViewProtocol> *)cardView;
- (void)removeCard:(UIView<BPCardViewProtocol> *)cardView;

@end