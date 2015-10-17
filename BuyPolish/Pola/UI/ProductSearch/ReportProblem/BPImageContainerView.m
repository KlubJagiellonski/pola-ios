//
// Created by Paweł on 17/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPImageContainerView.h"

const int MAX_IMAGE_COUNT = 3;
const int PADDING = 10;
const int ITEM_MARGIN = 6;
const int REMOVE_ITEM_MARGIN = 6;

const CGFloat ANIMATION_DURATION = 0.7f;

@interface BPImageContainerView ()
@property(nonatomic, readonly) NSMutableArray *imageViewArray;
@property(nonatomic, readonly) NSMutableArray *deleteButtonArray;
@property(nonatomic, readonly) UIButton *addImageButton;
@end

@implementation BPImageContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];

        _imageViewArray = [NSMutableArray arrayWithCapacity:MAX_IMAGE_COUNT];
        _deleteButtonArray = [NSMutableArray arrayWithCapacity:MAX_IMAGE_COUNT];

        _addImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addImageButton addTarget:self action:@selector(didTapAddImageButton:) forControlEvents:UIControlEventTouchUpInside];
        [_addImageButton setTitle:@"Add" forState:UIControlStateNormal];
        [self addSubview:_addImageButton];
    }

    return self;
}

- (void)didTapAddImageButton:(UIButton *)button {
    [self.delegate didTapAddImage:self];
}

- (void)didTapDeleteButton:(UIButton *)button {
    NSUInteger index = [self.deleteButtonArray indexOfObject:button];
    [self.delegate didTapRemoveImage:self atIndex:index];
}


- (void)addImage:(UIImage *)image {
    [self layoutIfNeeded];

    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.frame = self.addImageButton.frame;
    imageView.alpha = 0.f;
    [self addSubview:imageView];
    [self.imageViewArray addObject:imageView];


    UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteButton addTarget:self action:@selector(didTapDeleteButton:) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.alpha = 0.f;
    [deleteButton setTitle:@"Del" forState:UIControlStateNormal];
    [deleteButton sizeToFit];
    deleteButton.frame = [self calculateDeleteRect:deleteButton.frame ForImageRect:imageView.frame];
    [self addSubview:deleteButton];
    [self.deleteButtonArray addObject:deleteButton];

    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        imageView.alpha = 1.f;
        deleteButton.alpha = 1.f;

        [self setNeedsLayout];
        [self layoutIfNeeded];
    }];
}

- (void)removeImageAtIndex:(int)index {
    NSUInteger uIndex = (NSUInteger) index;
    UIView *imageView = self.imageViewArray[uIndex];
    UIView *deleteView = self.deleteButtonArray[uIndex];

    [self.deleteButtonArray removeObjectAtIndex:uIndex];
    [self.imageViewArray removeObjectAtIndex:uIndex];
    

    [UIView animateWithDuration:ANIMATION_DURATION animations:^{
        imageView.alpha = 0.f;
        deleteView.alpha = 0.f;

        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [imageView removeFromSuperview];
        [deleteView removeFromSuperview];
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat width = CGRectGetWidth(self.bounds);
    int itemWidth = [self calculateItemWidth:width];

    CGRect rect = CGRectZero;
    rect.origin.x = PADDING;
    rect.origin.y = PADDING;
    rect.size.width = itemWidth;
    rect.size.height = itemWidth;
    
    for (NSUInteger i = 0; i < [self.imageViewArray count]; i++) {
        UIView *view = self.imageViewArray[i];
        view.frame = rect;

        UIView *deleteView = self.deleteButtonArray[i];
        deleteView.frame = [self calculateDeleteRect:deleteView.frame ForImageRect:rect];

        rect.origin.x += CGRectGetWidth(rect) + ITEM_MARGIN;
    }

    self.addImageButton.frame = rect;
}

- (CGSize)sizeThatFits:(CGSize)size {
    int itemWidth = [self calculateItemWidth:size.width];
    size.height = itemWidth + 2 * PADDING;
    return size;
}

- (int)calculateItemWidth:(CGFloat)viewWidth {
    return (int) (viewWidth / MAX_IMAGE_COUNT - 2 * PADDING - (MAX_IMAGE_COUNT - 1) * ITEM_MARGIN);
}

- (CGRect) calculateDeleteRect:(CGRect)deleteRect ForImageRect:(CGRect)imageRect {
    deleteRect.origin.x = CGRectGetMaxX(imageRect) - REMOVE_ITEM_MARGIN - CGRectGetWidth(deleteRect);
    deleteRect.origin.y = CGRectGetMinY(imageRect) + REMOVE_ITEM_MARGIN;
    return deleteRect;
}

@end