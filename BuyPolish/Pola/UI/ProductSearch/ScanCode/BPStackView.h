//
// Created by Paweł on 03/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BPCardView;

@interface BPStackView : UIView

@property(nonatomic, readonly) NSInteger cardCount;

- (void)addCard:(BPCardView *)cardView;

@end