//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPStackView.h"
#import "BPCardView.h"


NSInteger const MAX_CARD_COUNT = 2;
NSInteger const CARD_MARGIN = 2;


NSInteger const STATE_STACK = 0;
NSInteger const STATE_FULL_SIZE = 1;


@interface BPStackView ()
@property(nonatomic, readonly) NSMutableArray *cardViewArray;
@property(nonatomic) NSInteger currentState;
@property(nonatomic) NSUInteger fullScreenCardViewIndex;
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
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardTapped:)];
    singleTap.numberOfTapsRequired = 1;
    [cardView setUserInteractionEnabled:YES];
    [cardView addGestureRecognizer:singleTap];

    CGRect cardInitialRect = [self getCardBaseRect];
    cardInitialRect.origin.y = CGRectGetHeight(self.bounds);
    cardView.frame = cardInitialRect;

    [self.cardViewArray addObject:cardView];
    [self addSubview:cardView];

    BPCardView *cardViewToRemove = nil;
    if (self.cardViewArray.count > MAX_CARD_COUNT) {
        cardViewToRemove = self.cardViewArray[0];
    }

    void (^animationBlock)() = ^{
        if (cardViewToRemove != nil) {
            cardViewToRemove.alpha = 0.0f;
        }

        [self setNeedsLayout];
        [self layoutIfNeeded];
    };

    void (^completionBlock)(BOOL) = ^(BOOL finished) {
        if (cardViewToRemove != nil) {
            [cardViewToRemove removeFromSuperview];
            [self.cardViewArray removeObject:cardViewToRemove];
        }
    };
    [UIView animateWithDuration:1.0f
                          delay:0
         usingSpringWithDamping:0.5f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:animationBlock
                     completion:completionBlock];
}

- (void)cardTapped:(UITapGestureRecognizer *)tapGestureRecognizer {
    BPCardView *tappedCardView = (BPCardView *) tapGestureRecognizer.view;
    
    self.currentState = STATE_FULL_SIZE;
    self.fullScreenCardViewIndex = [self.cardViewArray indexOfObject:tappedCardView];

    [UIView animateWithDuration:1.0f
                          delay:0
         usingSpringWithDamping:0.7f
          initialSpringVelocity:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         for (BPCardView *cardView in self.cardViewArray) {
                             if (cardView != tappedCardView) {
                                 cardView.alpha = 0.0f;
                             }
                         }
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
        [self layoutStackSubviews];
        [self layoutFullSizeSubview];
    }
}

- (void)layoutStackSubviews {
    CGRect cardRect = [self getCardBaseRect];
    cardRect.origin.y = CGRectGetHeight(self.bounds) - CARD_TITLE_HEIGHT;

    for (int i = [_cardViewArray count] - 1; i >= 0; i--) {
        BPCardView *cardView = self.cardViewArray[(NSUInteger) i];
        cardView.frame = cardRect;

        cardRect.origin.y -= CARD_TITLE_HEIGHT;
    }
}

- (void)layoutFullSizeSubview {
    BPCardView *cardView = self.cardViewArray[self.fullScreenCardViewIndex];
    cardView.frame = CGRectMake(CARD_MARGIN, CARD_MARGIN, CGRectGetWidth(self.bounds) - 2 * CARD_MARGIN, CGRectGetHeight(self.bounds) - 2 * CARD_MARGIN);
}

- (CGRect)getCardBaseRect {
    CGRect cardRect = CGRectZero;
    cardRect.size.width = CGRectGetWidth(self.bounds) - 2 * CARD_MARGIN;
    cardRect.size.height = CGRectGetHeight(self.bounds) - 2 * CARD_MARGIN;
    cardRect.origin.x = CARD_MARGIN;
    return cardRect;
}


@end