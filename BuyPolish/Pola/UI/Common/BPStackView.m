//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPStackView.h"
#import "UIApplication+BPStatusBarHeight.h"

NSInteger const kBPStackViewDefaultCardCountLimit = 4;
NSInteger const kBPStackViewCardMargin = 3;
NSInteger const kBPStackViewCardTitleHeight = 50;

@interface BPStackViewLayoutContext : NSObject

@property(nonatomic, assign, readwrite) UIEdgeInsets edgeInsets;
@property(nonatomic, assign, readwrite) CGFloat lookAhead;
@property(nonatomic, assign, readwrite) CGSize cardSize;
@property(nonatomic, assign, readwrite) NSUInteger cardCountLimit;

@end

@protocol BPStackViewLayout <NSObject>

@property(nonatomic, weak, readwrite) BPStackView *stackView;
@property(nonatomic, weak, readwrite) BPStackViewLayoutContext *layoutContext;

- (void)willBecomeActive;

- (void)didBecomeInactive;

- (void)didBecomeActive;

- (void)layoutCards:(NSArray<UIView *> *)cards;

- (void)didTapCardView:(UIView *)cardView recognizer:(UITapGestureRecognizer *)recognizer;

- (void)didPanCardView:(UIView *)cardView recognizer:(UIPanGestureRecognizer *)recognizer;
@end

@interface BPStackViewLayoutLayoutCollapsed : NSObject <BPStackViewLayout>

@property(nonatomic, weak, readwrite) UIView *offScreenCard;

@end

@interface BPStackViewLayoutExpanded : NSObject <BPStackViewLayout>

@property(nonatomic, weak, readwrite) UIView *selectedCard;

@end

@interface BPStackViewLayoutPick : NSObject <BPStackViewLayout>

@property(nonatomic, weak, readwrite) UIView *selectedCard;
@property(nonatomic, weak, readwrite) UIPanGestureRecognizer *panGestureRecognizer;

@end

@interface BPStackView ()

@property(nonatomic, strong, readwrite) id <BPStackViewLayout> currentLayout;

@end

@implementation BPStackView {
    NSMutableArray <UIView *> *_cards;

    BPStackViewLayoutContext *_layoutContext;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cards = [NSMutableArray array];
        _layoutContext = [BPStackViewLayoutContext new];
        _layoutContext.edgeInsets = UIEdgeInsetsMake([UIApplication statusBarHeight] + kBPStackViewCardMargin, kBPStackViewCardMargin, kBPStackViewCardMargin, kBPStackViewCardMargin);
        _layoutContext.lookAhead = kBPStackViewCardTitleHeight;
        _layoutContext.cardCountLimit = kBPStackViewDefaultCardCountLimit;

        [self setCurrentLayout:[BPStackViewLayoutLayoutCollapsed new]
                      animated:NO
               completionBlock:nil];
    }

    return self;
}

- (BOOL)addCard:(UIView *)cardView {
    if ([_cards indexOfObject:cardView] != NSNotFound) {
        return NO;
    }

    if ([cardView conformsToProtocol:@protocol(BPStackViewCardProtocol)]) {
        UIView <BPStackViewCardProtocol> *castCardView = (UIView <BPStackViewCardProtocol> *) cardView;
        [castCardView setTitleHeight:_layoutContext.lookAhead];
    }

    [self.delegate stackView:self willAddCard:cardView];

    [_cards addObject:cardView];
    [self addSubview:cardView];
    [self sendSubviewToBack:cardView];

    UIView *toBeRemovedCard = _cards.count > _layoutContext.cardCountLimit ? _cards[0] : nil;

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapCard:)];
    [cardView addGestureRecognizer:tapGestureRecognizer];

    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPanCard:)];
    [cardView addGestureRecognizer:panGestureRecognizer];

    //Step 1: place the card off screen

    BPStackViewLayoutLayoutCollapsed *collapsedLayout = [BPStackViewLayoutLayoutCollapsed new];
    collapsedLayout.offScreenCard = cardView;

    [self setCurrentLayout:collapsedLayout
                  animated:NO
           completionBlock:nil];

    //Step 2: animate on screen (optionally move over limit card off screen and remove after it's done)
    __weak typeof(_cards) weakCards = _cards;
    __weak typeof(self) weakSelf = self;
    collapsedLayout.offScreenCard = toBeRemovedCard;
    [self setCurrentLayout:collapsedLayout
                  animated:YES
           completionBlock:^{
               if (toBeRemovedCard != nil) {
                   [weakCards removeObject:toBeRemovedCard];
                   [toBeRemovedCard removeFromSuperview];
                   [weakSelf.delegate stackView:weakSelf didRemoveCard:toBeRemovedCard];
               }
           }];

    return YES;
}

- (void)removeCard:(UIView *)cardView {
    if ([_cards indexOfObject:cardView] == NSNotFound) {
        return;
    }

    BPStackViewLayoutLayoutCollapsed *collapsedLayout = [BPStackViewLayoutLayoutCollapsed new];
    collapsedLayout.offScreenCard = cardView;

    __weak typeof(_cards) weakCards = _cards;
    __weak typeof(self) weakSelf = self;
    [self setCurrentLayout:collapsedLayout
                  animated:YES
           completionBlock:^{
               [weakCards removeObject:cardView];
               [cardView removeFromSuperview];
               [weakSelf.delegate stackView:weakSelf didRemoveCard:cardView];
           }];
}

- (void)setCurrentLayout:(id <BPStackViewLayout>)currentLayout {
    [self setCurrentLayout:currentLayout animated:YES completionBlock:nil];
}

- (void)setCurrentLayout:(id <BPStackViewLayout>)currentLayout animated:(BOOL)animated completionBlock:(void (^)())completionBlock {
    id <BPStackViewLayout> oldLayout = nil;

    BOOL changingLayout = _currentLayout != currentLayout;
    if (changingLayout) {
        oldLayout = _currentLayout;
        _currentLayout = currentLayout;
        _currentLayout.stackView = self;
        _currentLayout.layoutContext = _layoutContext;
        [_currentLayout willBecomeActive];
    }

    if (completionBlock == nil) {
        completionBlock = ^{
        };
    }

    void (^forceLayout)() = ^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    };

    weakify();
    void (^completionBlockWrapper)() = ^() {
        strongify();
        if (changingLayout) {
            [oldLayout didBecomeInactive];
            [strongSelf.currentLayout didBecomeActive];
        }
        completionBlock();
    };

    if (animated) {
        [UIView animateWithDuration:0.8f
                              delay:0
             usingSpringWithDamping:0.7f
              initialSpringVelocity:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState
                         animations:forceLayout
                         completion:^(BOOL finished) {
                             completionBlockWrapper();
                         }];
    } else {
        forceLayout();
        completionBlockWrapper();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    _layoutContext.cardSize = CGSizeMake(
        self.bounds.size.width - _layoutContext.edgeInsets.left - _layoutContext.edgeInsets.right,
        self.bounds.size.height - _layoutContext.edgeInsets.top - _layoutContext.edgeInsets.bottom - _layoutContext.lookAhead
    );

    [_currentLayout layoutCards:_cards];
}

- (void)didTapCard:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;

    [_currentLayout didTapCardView:view recognizer:recognizer];
}

- (void)didPanCard:(UIPanGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;

    [_currentLayout didPanCardView:view recognizer:recognizer];
}

@end

@implementation BPStackViewLayoutContext

@end

@implementation BPStackViewLayoutLayoutCollapsed

@synthesize stackView = _stackView, layoutContext = _layoutContext;

- (void)willBecomeActive {

}

- (void)didBecomeInactive {

}

- (void)didBecomeActive {

}

- (void)layoutCards:(NSArray<UIView *> *)cards {
    NSInteger cardFromBottom = 0;
    for (NSUInteger i = 0; i < cards.count; ++i) {
        UIView *card = cards[i];

        BOOL isOffScreenCard = card == _offScreenCard;

        CGRect frame;

        if (isOffScreenCard) {
            frame = CGRectMake(
                _layoutContext.edgeInsets.left,
                _stackView.bounds.size.height,
                _layoutContext.cardSize.width,
                _layoutContext.cardSize.height);
        } else {
            frame = CGRectMake(
                _layoutContext.edgeInsets.left,
                _stackView.bounds.size.height - _layoutContext.edgeInsets.bottom - _layoutContext.lookAhead * (cardFromBottom + 1),
                _layoutContext.cardSize.width,
                _layoutContext.cardSize.height);
            ++cardFromBottom;
        }

        card.frame = frame;
    }
}

- (void)didTapCardView:(UIView *)cardView recognizer:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateRecognized) {
        return;
    }

    if ([_stackView.delegate stackView:_stackView didTapCard:cardView]) {
        return;
    }

    BPStackViewLayoutExpanded *expandedLayout = [BPStackViewLayoutExpanded new];
    expandedLayout.selectedCard = cardView;
    [_stackView setCurrentLayout:expandedLayout
                        animated:YES
                 completionBlock:nil];
}

- (void)didPanCardView:(UIView *)cardView recognizer:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        BPStackViewLayoutPick *pickLayout = [BPStackViewLayoutPick new];
        pickLayout.selectedCard = cardView;
        pickLayout.panGestureRecognizer = recognizer;
        [_stackView setCurrentLayout:pickLayout
                            animated:NO
                     completionBlock:nil];
    }
}

@end

@implementation BPStackViewLayoutExpanded {
    CGFloat _drag;
}

@synthesize stackView = _stackView, layoutContext = _layoutContext;

- (void)willBecomeActive {
    [_stackView.delegate stackView:_stackView willExpandWithCard:self.selectedCard];
}

- (void)didBecomeInactive {
    [_stackView.delegate stackViewDidCollapse:_stackView];

    [self changeSelectedCardFocus:NO];
}

- (void)didBecomeActive {
    [self changeSelectedCardFocus:YES];
}

- (void)changeSelectedCardFocus:(BOOL)focused {
    if ([self.selectedCard conformsToProtocol:@protocol(BPStackViewCardProtocol)]) {
        UIView <BPStackViewCardProtocol> *castCardView = (UIView <BPStackViewCardProtocol> *) self.selectedCard;
        [castCardView setFocused:focused];
    }
}

- (void)layoutCards:(NSArray<UIView *> *)cards {
    for (NSUInteger i = 0; i < cards.count; ++i) {
        UIView *card = cards[i];

        BOOL isSelectedCard = card == _selectedCard;

        CGFloat (^dumpingFunction)(CGFloat x) = ^CGFloat(CGFloat x) {
            if (x == 0) {
                return 0;
            } else if (x > 0) {
                return -(1.0f / (x + 1.0f) - 1.0f);
            } else {
                return -(1.0f / (x - 1.0f) + 1.0f);
            }
        };

        CGRect frame = CGRectMake(
            _layoutContext.edgeInsets.left,
            isSelectedCard ? _layoutContext.edgeInsets.top + dumpingFunction(_drag / 100.0f) * 100.0f : _stackView.bounds.size.height - _layoutContext.lookAhead * (i + 1) * 0.2f,
            _layoutContext.cardSize.width,
            _layoutContext.cardSize.height);

        card.frame = frame;
    }
}

- (void)didTapCardView:(UIView *)cardView recognizer:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateRecognized) {
        return;
    }

    [_stackView setCurrentLayout:[BPStackViewLayoutLayoutCollapsed new]
                        animated:YES
                 completionBlock:nil];
}

- (void)didPanCardView:(UIView *)cardView recognizer:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        _drag = [recognizer translationInView:_stackView].y;
        [_stackView setCurrentLayout:self
                            animated:NO
                     completionBlock:nil];
    } else if (recognizer.state == UIGestureRecognizerStateRecognized) {
        if (_drag > 100) {
            [_stackView setCurrentLayout:[BPStackViewLayoutLayoutCollapsed new]
                                animated:YES
                         completionBlock:nil];
        } else {
            _drag = 0;
            [_stackView setCurrentLayout:self
                                animated:YES
                         completionBlock:nil];
        }
    }
}

@end

@implementation BPStackViewLayoutPick

@synthesize stackView = _stackView, layoutContext = _layoutContext;

- (void)willBecomeActive {

}

- (void)didBecomeInactive {

}

- (void)didBecomeActive {

}


- (void)layoutCards:(NSArray<UIView *> *)cards {
    for (NSUInteger i = 0; i < cards.count; ++i) {
        UIView *card = cards[i];

        BOOL isSelectedCard = card == _selectedCard;

        CGRect frame = CGRectMake(
            _layoutContext.edgeInsets.left,
            _stackView.bounds.size.height - _layoutContext.edgeInsets.bottom - _layoutContext.lookAhead * (i + 1),
            _layoutContext.cardSize.width,
            _layoutContext.cardSize.height);

        if (isSelectedCard) {
            CGPoint offset = [_panGestureRecognizer translationInView:_stackView];
            frame.origin.y += offset.y;
        }

        card.frame = frame;
    }
}

- (void)didTapCardView:(UIView *)cardView recognizer:(UITapGestureRecognizer *)recognizer {

}

- (void)didPanCardView:(UIView *)cardView recognizer:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        CGPoint offset = [_panGestureRecognizer translationInView:_stackView];
        if (offset.y < -100) {
            BPStackViewLayoutExpanded *expandedLayout = [BPStackViewLayoutExpanded new];
            expandedLayout.selectedCard = cardView;
            [_stackView setCurrentLayout:expandedLayout
                                animated:YES
                         completionBlock:nil];
        } else {
            [_stackView setCurrentLayout:[BPStackViewLayoutLayoutCollapsed new]
                                animated:YES
                         completionBlock:nil];
        }
    } else {
        [_stackView setCurrentLayout:self
                            animated:NO
                     completionBlock:nil];
    }
}

@end
