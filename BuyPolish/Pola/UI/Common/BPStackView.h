//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPStackView;


@protocol BPStackViewDelegate <NSObject>

- (void)stackView:(BPStackView *)stackView willAddCard:(UIView *)cardView;

- (void)stackView:(BPStackView *)stackView didRemoveCard:(UIView *)cardView;

- (void)stackView:(BPStackView *)stackView willExpandWithCard:(UIView *)cardView;

- (void)stackViewDidCollapse:(BPStackView *)stackView;

- (BOOL)stackView:(BPStackView *)stackView didTapCard:(UIView *)cardView;

@end

@protocol BPStackViewCardProtocol <NSObject>

- (void)setTitleHeight:(CGFloat)titleHeight;

@end

@interface BPStackView : UIView

@property(nonatomic, weak) id <BPStackViewDelegate> delegate;
@property(nonatomic, readonly) NSInteger cardCount;

- (BOOL)addCard:(UIView *)cardView;

- (void)removeCard:(UIView *)cardView;

@end