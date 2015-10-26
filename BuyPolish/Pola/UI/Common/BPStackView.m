//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPStackView.h"
#import "BPCardViewProtocol.h"
#import "BPConst.h"

NSInteger const MAX_CARD_COUNT = 4;
NSInteger const CARD_MARGIN = 3;
NSInteger const CARD_TITLE_HEIGHT = 50;
NSInteger const CARD_SMALL_TITLE_HEIGHT = 15;

NSInteger const STATE_STACK = 0;
NSInteger const STATE_FULL_SIZE = 1;

float const ADD_CARD_ANIMATION_DURATION = 0.8f;
const float SHOW_FULL_CARD_ANIMATION_DURATION = 0.7f;
const float PAN_THRESHOLD_TO_SHOW_OR_HIDE_FULL_SCREEN = 20;


@interface BPStackView ()
@property(nonatomic, readonly) NSMutableArray *cardViewArray;
@property(nonatomic) NSInteger currentState;
@property(nonatomic) NSUInteger fullScreenCardViewIndex;
@property(nonatomic) BOOL animationInProgress;
@end

@implementation BPStackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentState = STATE_STACK;
        _cardViewArray = [NSMutableArray array];

        [self setAlwaysBounceVertical:YES];
        [self setShowsVerticalScrollIndicator:NO];

        [self.panGestureRecognizer addTarget:self action:@selector(onPanChanged:)];
    }

    return self;
}

- (void)onPanChanged:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self];
    if (self.currentState == STATE_STACK) {
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded && translation.y < 0
                && ABS(translation.y) >= PAN_THRESHOLD_TO_SHOW_OR_HIDE_FULL_SCREEN) {
            [self animateToFullScreen:self.cardViewArray.lastObject];
        }
    } else if (self.currentState == STATE_FULL_SIZE) {
        if (panGestureRecognizer.state == UIGestureRecognizerStateEnded && translation.y > 0
                && ABS(translation.y) >= PAN_THRESHOLD_TO_SHOW_OR_HIDE_FULL_SCREEN) {
            [self animateToStack];
        } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            [self layoutShowingStackSubviews];
        }
    }
}

- (BOOL)addCard:(UIView <BPCardViewProtocol> *)cardView {
    if (self.animationInProgress || self.currentState != STATE_STACK) {
        return NO;
    }

    [cardView setTitleHeight:CARD_TITLE_HEIGHT];

    self.animationInProgress = YES;

    [self addGestureRecognizersToCardView:cardView];

    [self.stackDelegate willAddCard:cardView withAnimationDuration:ADD_CARD_ANIMATION_DURATION];

    CGRect cardInitialRect = [self getCardBaseRect];
    cardInitialRect.origin.y = CGRectGetHeight(self.bounds) - self.cardViewArray.count * CARD_TITLE_HEIGHT;
    cardView.frame = cardInitialRect;
    cardView.alpha = 0.f;
    [self.cardViewArray addObject:cardView];
    [self insertSubview:cardView atIndex:0];

    UIView <BPCardViewProtocol> *cardViewToRemove;
    if (self.cardViewArray.count > MAX_CARD_COUNT) {
        cardViewToRemove = self.cardViewArray[0];
    }

    void (^layoutAnimationBlock)() = ^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    };

    void (^firstAnimationBlock)() = ^{
        cardView.alpha = 1.f;
        layoutAnimationBlock();
    };

    void (^firstAnimationPhaseCompletionBlock)(BOOL) = ^(BOOL finished) {
        [self.cardViewArray removeObject:cardViewToRemove];

        CGRect endFrame = cardViewToRemove.frame;
        endFrame.origin.y = CGRectGetHeight(self.bounds);
        void (^secondAnimationBlock)() = ^{
            cardViewToRemove.frame = endFrame;
            cardViewToRemove.alpha = 0.f;
            layoutAnimationBlock();
        };

        void (^secondAnimationCompletionBlock)(BOOL) = ^(BOOL finished) {
            [cardViewToRemove removeFromSuperview];

            self.animationInProgress = NO;
        };
        [UIView animateWithDuration:ADD_CARD_ANIMATION_DURATION / 2
                              delay:0
             usingSpringWithDamping:0.5f
              initialSpringVelocity:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:secondAnimationBlock
                         completion:secondAnimationCompletionBlock];
    };

    [UIView animateWithDuration:ADD_CARD_ANIMATION_DURATION / 2
                          delay:0
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:firstAnimationBlock
                     completion:firstAnimationPhaseCompletionBlock];

    return YES;
}

- (void)addGestureRecognizersToCardView:(UIView <BPCardViewProtocol> *)cardView {
    [cardView setUserInteractionEnabled:YES];

    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)];
    singleTap.numberOfTapsRequired = 1;
    [cardView addGestureRecognizer:singleTap];
}

- (void)cardTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIView <BPCardViewProtocol> *tappedCardView = (UIView <BPCardViewProtocol> *) tapGestureRecognizer.view;

    if (self.currentState == STATE_STACK) {
        [self animateToFullScreen:tappedCardView];
    } else if (self.currentState == STATE_FULL_SIZE && [self.cardViewArray indexOfObject:tappedCardView] != self.fullScreenCardViewIndex) {
        [self animateToStack];
    }
}

- (void)animateToStack {
    NSUInteger lastFullScreenCardViewIndex = self.fullScreenCardViewIndex;

    self.currentState = STATE_STACK;
    self.fullScreenCardViewIndex = 0;

    [UIView animateWithDuration:SHOW_FULL_CARD_ANIMATION_DURATION
                          delay:0
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setNeedsLayout];
                         [self layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self.stackDelegate didExitFullScreen:self.cardViewArray[lastFullScreenCardViewIndex]];
                     }];
}

- (void)animateToFullScreen:(UIView <BPCardViewProtocol> *)tappedCardView {
    if(![self.cardViewArray containsObject:tappedCardView]) {
        return;
    }

    [self.stackDelegate willEnterFullScreen:tappedCardView withAnimationDuration:SHOW_FULL_CARD_ANIMATION_DURATION];

    self.currentState = STATE_FULL_SIZE;
    self.fullScreenCardViewIndex = [self.cardViewArray indexOfObject:tappedCardView];

    [UIView animateWithDuration:SHOW_FULL_CARD_ANIMATION_DURATION
                          delay:0
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self setNeedsLayout];
                         [self layoutIfNeeded];
                     }
                     completion:nil];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.contentSize = self.bounds.size;

    if (self.currentState == STATE_STACK) {
        [self layoutStackSubviews];
    } else if (self.currentState == STATE_FULL_SIZE) {
        [self layoutShowingStackSubviews];
        [self layoutFullSizeSubview];
    }
}

- (void)layoutStackSubviews {
    CGRect cardRect = [self getCardBaseRect];
    cardRect.origin.y = CGRectGetHeight(self.bounds) - CARD_TITLE_HEIGHT;

    for (UIView <BPCardViewProtocol> *cardView in self.cardViewArray) {
        cardView.frame = cardRect;

        cardRect.origin.y -= CARD_TITLE_HEIGHT;
    }
}

- (void)layoutFullSizeSubview {
    UIView <BPCardViewProtocol> *cardView = self.cardViewArray[self.fullScreenCardViewIndex];
    CGFloat height = CGRectGetHeight(self.bounds) - 3 * CARD_MARGIN - (MAX_CARD_COUNT - 1) * CARD_SMALL_TITLE_HEIGHT - STATUS_BAR_HEIGHT;
    cardView.frame = CGRectMake(CARD_MARGIN, STATUS_BAR_HEIGHT + CARD_MARGIN, CGRectGetWidth(self.bounds) - 2 * CARD_MARGIN, height);
}

- (void)layoutShowingStackSubviews {
    CGRect cardRect = [self getCardBaseRect];
    cardRect.origin.y = CGRectGetHeight(self.bounds) - CARD_SMALL_TITLE_HEIGHT + self.contentOffset.y;

    int i = 0;
    for (UIView <BPCardViewProtocol> *cardView in self.cardViewArray) {
        if (i == self.fullScreenCardViewIndex) {
            i++;
            continue;
        }

        cardView.frame = cardRect;

        cardRect.origin.y -= CARD_SMALL_TITLE_HEIGHT;
        i++;
    }
}

- (CGRect)getCardBaseRect {
    CGRect cardRect = CGRectZero;
    cardRect.size.width = CGRectGetWidth(self.bounds) - 2 * CARD_MARGIN;
    cardRect.size.height = CGRectGetHeight(self.bounds) - 2 * CARD_MARGIN;
    cardRect.origin.x = CARD_MARGIN;
    return cardRect;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


@end