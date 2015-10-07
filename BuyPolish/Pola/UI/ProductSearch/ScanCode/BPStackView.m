//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPStackView.h"
#import "BPCardView.h"


NSInteger const MAX_CARD_COUNT = 2;
NSInteger const CARD_MARGIN = 2;
NSInteger const CARD_SMALL_TITLE_HEIGHT = 15;
float const MAX_PAN_Y = -50;
int const PAN_MULITIPLIER = 10;

NSInteger const STATE_STACK = 0;
NSInteger const STATE_FULL_SIZE = 1;

float const ADD_CARD_ANIMATION_DURATION = 0.8f;
const float SHOW_FULL_CARD_ANIMATION_DURATION = 1.0f;


@interface BPStackView ()
@property(nonatomic, readonly) NSMutableArray *cardViewArray;
@property(nonatomic) NSInteger currentState;
@property(nonatomic) NSUInteger fullScreenCardViewIndex;
@property(nonatomic) BOOL animationInProgress;
@property(nonatomic) float currentPanY;
@end

@implementation BPStackView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _currentState = STATE_STACK;
        _cardViewArray = [NSMutableArray array];
        self.currentPanY = 0;

        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
        [self addGestureRecognizer:panGestureRecognizer];
    }

    return self;
}

- (void)onPanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (self.currentState == STATE_STACK) {
        [self handlePanGestureInStackState:panGestureRecognizer];
    } else if (self.currentState == STATE_FULL_SIZE) {
        //todo
    }
}

- (void)handlePanGestureInStackState:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:self];

    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.currentPanY = 0;
        if (translation.y < MAX_PAN_Y / 2 || translation.y < 10) {
            [self animateToFullScreen:self.cardViewArray.lastObject];
        } else {
            [UIView animateWithDuration:0.5f animations:^{
                [self setNeedsLayout];
                [self layoutIfNeeded];
            }];
        }
    } else {
        self.currentPanY = (int) translation.y;

        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (BOOL)addCard:(BPCardView *)cardView {
    if (self.animationInProgress || self.currentState != STATE_STACK) {
        return NO;
    }

    self.animationInProgress = YES;

    [self addTapGestureToCardView:cardView];

    [self.delegate willAddCard:cardView withAnimationDuration:ADD_CARD_ANIMATION_DURATION];

    CGRect cardInitialRect = [self getCardBaseRect];
    cardInitialRect.origin.y = CGRectGetHeight(self.bounds) - self.cardViewArray.count * CARD_TITLE_HEIGHT;
    cardView.frame = cardInitialRect;
    cardView.alpha = 0.f;
    [self.cardViewArray addObject:cardView];
    [self insertSubview:cardView atIndex:0];

    BPCardView *cardViewToRemove;
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

- (void)addTapGestureToCardView:(BPCardView *)cardView {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)];
    singleTap.numberOfTapsRequired = 1;
    [cardView setUserInteractionEnabled:YES];
    [cardView addGestureRecognizer:singleTap];
}

- (void)cardTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    BPCardView *tappedCardView = (BPCardView *) tapGestureRecognizer.view;

    if (self.currentState == STATE_STACK) {
        [self animateToFullScreen:tappedCardView];
    } else if (self.currentState == STATE_FULL_SIZE && [self.cardViewArray indexOfObject:tappedCardView] != self.fullScreenCardViewIndex) {
        [self animateToStack];
    }
}

- (void)animateToStack {
    [self.delegate willExitFullScreen:self.cardViewArray[self.fullScreenCardViewIndex] withAnimationDuration:SHOW_FULL_CARD_ANIMATION_DURATION];

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
                     completion:nil];
}

- (void)animateToFullScreen:(BPCardView *)tappedCardView {
    [self.delegate willEnterFullScreen:tappedCardView withAnimationDuration:SHOW_FULL_CARD_ANIMATION_DURATION];

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
    }
}

- (void)layoutStackSubviews {
    float yOffset = 0;
    float currentPanY = self.currentPanY;
    float maxPanWithMultiplier = MAX_PAN_Y * PAN_MULITIPLIER;
    if (currentPanY < 0) {
        if (currentPanY < maxPanWithMultiplier) {
            yOffset = maxPanWithMultiplier;
        } else {
            yOffset = -(currentPanY * currentPanY / maxPanWithMultiplier) + 2 * currentPanY;
        }
        yOffset /= PAN_MULITIPLIER;
    }

    CGRect cardRect = [self getCardBaseRect];
    cardRect.origin.y = CGRectGetHeight(self.bounds) - CARD_TITLE_HEIGHT + yOffset;

    for (BPCardView *cardView in self.cardViewArray) {
        cardView.frame = cardRect;

        cardRect.origin.y -= CARD_TITLE_HEIGHT;
    }
}

- (void)layoutFullSizeSubview {
    BPCardView *cardView = self.cardViewArray[self.fullScreenCardViewIndex];
    CGFloat height = CGRectGetHeight(self.bounds) - 3 * CARD_MARGIN - ([self.cardViewArray count] - 1) * CARD_SMALL_TITLE_HEIGHT;
    cardView.frame = CGRectMake(CARD_MARGIN, CARD_MARGIN, CGRectGetWidth(self.bounds) - 2 * CARD_MARGIN, height);
}

- (void)layoutShowingStackSubviews {
    CGRect cardRect = [self getCardBaseRect];
    cardRect.origin.y = CGRectGetHeight(self.bounds) - CARD_SMALL_TITLE_HEIGHT;

    int i = 0;
    for (BPCardView *cardView in self.cardViewArray) {
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

- (int)cardViewsHeight {
    return (int) self.cardViewArray.count * (int) CARD_TITLE_HEIGHT;
}

@end