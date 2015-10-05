//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPCardView;


@protocol BPStackViewDelegate <NSObject>

- (void)willAddCard:(BPCardView *)cardView withAnimationDuration:(CGFloat)animationDuration;
- (void)willEnterFullScreen:(BPCardView *)cardView withAnimationDuration:(CGFloat)animationDuration;
- (void)willExitFullScreen:(BPCardView *)cardView withAnimationDuration:(CGFloat)animationDuration;

@end


@interface BPStackView : UIView

@property(nonatomic, weak) id <BPStackViewDelegate> delegate;
@property(nonatomic, readonly) NSInteger cardCount;
@property(nonatomic, readonly) int cardViewsHeight;

- (BOOL)addCard:(BPCardView *)cardView;

@end