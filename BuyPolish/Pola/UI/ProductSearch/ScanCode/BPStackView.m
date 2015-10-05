//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPStackView.h"
#import "BPCardView.h"


NSInteger const MAX_CARD_COUNT = 2;
NSInteger const CARD_MARGIN = 2;
NSInteger const CARD_SMALL_TITLE_HEIGHT = 5;


NSInteger const STATE_STACK = 0;
NSInteger const STATE_FULL_SIZE = 1;
NSInteger const STATE_SMALL_CARDS = 2;
NSInteger const STATE_SMALL_CARDS_WITH_NEW_SHOW = 3;

float const ADD_CARD_SHORT_PHASE_DURATION = 0.2f;
float const ADD_CARD_LONG_PHASE_DURATION = 0.5f;
const float SHOW_FULL_CARD_ANIMATION_DURATION = 1.0f;


@interface BPStackView ()
@property(nonatomic, readonly) NSMutableArray *cardViewArray;
@property(nonatomic) NSInteger currentState;
@property(nonatomic) NSUInteger fullScreenCardViewIndex;
@property(nonatomic) BPCardView *cardViewToRemove;
@end

@implementation BPStackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentState = STATE_STACK;
        _cardViewArray = [NSMutableArray array];
    }

    return self;
}

- (void)addCard:(BPCardView *)cardView {
    [self addTapGestureToCardView:cardView];

    [self.delegate willAddCard:cardView withAnimationDuration:ADD_CARD_SHORT_PHASE_DURATION * 2 + ADD_CARD_LONG_PHASE_DURATION];

    CGRect cardInitialRect = [self getCardBaseRect];
    cardInitialRect.origin.y = CGRectGetHeight(self.bounds);
    cardView.frame = cardInitialRect;

    self.currentState = STATE_SMALL_CARDS;

    if (self.cardViewArray.count > MAX_CARD_COUNT) {
        self.cardViewToRemove = self.cardViewArray[0];
        [self.cardViewArray removeObject:self.cardViewToRemove];
    }

    void (^layoutAnimationBlock)() = ^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    };

    void (^secondAnimationPhaseCompletionBlock)(BOOL) = ^(BOOL finished) {
        [self.cardViewToRemove removeFromSuperview];
        self.cardViewToRemove = nil;

        self.currentState = STATE_STACK;

        [UIView animateWithDuration:ADD_CARD_SHORT_PHASE_DURATION animations:layoutAnimationBlock];
    };

    void (^firstAnimationPhase)() = ^{
        CGRect removeCardRect = self.cardViewToRemove.frame;
        removeCardRect.origin.y = CGRectGetHeight(self.bounds);
        self.cardViewToRemove.frame = removeCardRect;
        layoutAnimationBlock();
    };

    void (^firstAnimationPhaseCompletionBlock)(BOOL) = ^(BOOL finished) {
        [self.cardViewArray addObject:cardView];
        [self insertSubview:cardView atIndex:0];

        self.currentState = STATE_SMALL_CARDS_WITH_NEW_SHOW;

        [UIView animateWithDuration:ADD_CARD_LONG_PHASE_DURATION
                              delay:0
             usingSpringWithDamping:0.5f
              initialSpringVelocity:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:layoutAnimationBlock
                         completion:secondAnimationPhaseCompletionBlock];
    };

    [UIView animateWithDuration:ADD_CARD_SHORT_PHASE_DURATION
                     animations:firstAnimationPhase
                     completion:firstAnimationPhaseCompletionBlock];
}

- (void)addTapGestureToCardView:(BPCardView *)cardView {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)];
    singleTap.numberOfTapsRequired = 1;
    [cardView setUserInteractionEnabled:YES];
    [cardView addGestureRecognizer:singleTap];
}

- (void)cardTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    BPCardView *tappedCardView = (BPCardView *) tapGestureRecognizer.view;

    [self.delegate willEnterFullScreen:tappedCardView withAnimationDuration:SHOW_FULL_CARD_ANIMATION_DURATION];

    self.currentState = STATE_FULL_SIZE;
    self.fullScreenCardViewIndex = [self.cardViewArray indexOfObject:tappedCardView];

    const float ALPHA_ANIMATION_STEP_DURATION = SHOW_FULL_CARD_ANIMATION_DURATION / 2;

    [UIView animateWithDuration:ALPHA_ANIMATION_STEP_DURATION animations:^{
        for (BPCardView *cardView in self.cardViewArray) {
            if (cardView != tappedCardView) {
                cardView.alpha = 0.0f;
            }
        }
    }                completion:^(BOOL finished) {
        [UIView animateWithDuration:ALPHA_ANIMATION_STEP_DURATION animations:^{
            for (BPCardView *cardView in self.cardViewArray) {
                if (cardView != tappedCardView) {
                    cardView.alpha = 1.0f;
                }
            }
        }];
    }];

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

- (NSInteger)cardCount {
    return self.cardViewArray.count;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if (self.currentState == STATE_STACK) {
        [self layoutStackSubviews];
    } else if (self.currentState == STATE_FULL_SIZE) {
        [self layoutShowingStackSubviews];
        [self layoutFullSizeSubview];
    } else if (self.currentState == STATE_SMALL_CARDS) {
        [self layoutShowingStackSubviews];
    } else if (self.currentState == STATE_SMALL_CARDS_WITH_NEW_SHOW) {
        [self layoutShowingStackSubviews];
        [self layoutShowingNewStackSubview];
    }
}

- (void)layoutStackSubviews {
    CGRect cardRect = [self getCardBaseRect];
    cardRect.origin.y = CGRectGetHeight(self.bounds) - CARD_TITLE_HEIGHT;

    for (BPCardView *cardView in self.cardViewArray) {
        cardView.frame = cardRect;

        cardRect.origin.y -= CARD_TITLE_HEIGHT;
    }
}

- (void)layoutFullSizeSubview {
    BPCardView *cardView = self.cardViewArray[self.fullScreenCardViewIndex];
    CGFloat height = CGRectGetHeight(self.bounds) - 3 * CARD_MARGIN - [self.cardViewArray count] * CARD_SMALL_TITLE_HEIGHT;
    cardView.frame = CGRectMake(CARD_MARGIN, CARD_MARGIN, CGRectGetWidth(self.bounds) - 2 * CARD_MARGIN, height);
}

- (void)layoutShowingStackSubviews {
    CGRect cardRect = [self getCardBaseRect];
    cardRect.origin.y = CGRectGetHeight(self.bounds) - CARD_SMALL_TITLE_HEIGHT;

    for (BPCardView *cardView in self.cardViewArray) {
        cardView.frame = cardRect;

        cardRect.origin.y -= CARD_SMALL_TITLE_HEIGHT;
    }
}

- (void)layoutShowingNewStackSubview {
    BPCardView *cardView = self.cardViewArray.lastObject;
    CGRect cardRect = [self getCardBaseRect];
    cardRect.origin.y = CGRectGetHeight(self.bounds) - (self.cardViewArray.count - 1) * CARD_TITLE_HEIGHT;
    cardView.frame = cardRect;
}

- (CGRect)getCardBaseRect {
    CGRect cardRect = CGRectZero;
    cardRect.size.width = CGRectGetWidth(self.bounds) - 2 * CARD_MARGIN;
    cardRect.size.height = CGRectGetHeight(self.bounds) - 2 * CARD_MARGIN;
    cardRect.origin.x = CARD_MARGIN;
    return cardRect;
}

- (int)cardViewsHeight {
    return self.cardViewArray.count * CARD_TITLE_HEIGHT;
}

@end