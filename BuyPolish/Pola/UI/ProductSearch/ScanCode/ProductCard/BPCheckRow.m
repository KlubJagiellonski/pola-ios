//
// Created by Paweł on 21/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPCheckRow.h"
#import "BPTheme.h"
#import "UILabel+BPAdditions.h"


const int CHECK_ROW_HORIZONTAL_MARGIN = 7;
const int CHECK_ROW_NOTES_MARGIN = 4;


@interface BPCheckRow ()
@property(nonatomic, readonly) UIImageView *checkImageView;
@property(nonatomic, readonly) UILabel *textLabel;
@property(nonatomic, readonly) UILabel *notesLabel;
@end

@implementation BPCheckRow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _checkImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _checkImageView.tintColor = [BPTheme defaultTextColor];
        [self addSubview:_checkImageView];

        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.font = [BPTheme normalFont];
        _textLabel.textColor = [BPTheme defaultTextColor];
        [self addSubview:_textLabel];

        _notesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _notesLabel.numberOfLines = 0;
        _notesLabel.font = [BPTheme captionFont];
        _notesLabel.textColor = [BPTheme defaultTextColor];
        [self addSubview:_notesLabel];

        [self configure:nil notes:nil];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.checkImageView.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    self.checkImageView.frame = rect;

    rect = self.textLabel.frame;
    rect.origin.x = CGRectGetMaxX(self.checkImageView.frame) + CHECK_ROW_HORIZONTAL_MARGIN;
    rect.origin.y = CGRectGetHeight(self.checkImageView.bounds) / 2 - CGRectGetHeight(rect) / 2;
    self.textLabel.frame = rect;

    rect = self.notesLabel.frame;
    rect.size.width = CGRectGetWidth(self.bounds);
    rect.size.height = [self.notesLabel heightForWidth:CGRectGetWidth(rect)];
    rect.origin.x = 0;
    rect.origin.y = MAX(CGRectGetMaxY(self.checkImageView.frame), CGRectGetMaxY(self.textLabel.frame)) + CHECK_ROW_NOTES_MARGIN;
    self.notesLabel.frame = rect;
}

- (void)setText:(NSString *)text {
    self.textLabel.text = text;
    [self.textLabel sizeToFit];
    [self setNeedsLayout];
}

- (void)configure:(NSNumber *)checked notes:(NSString *)notes {
    UIImage *image;
    if (!checked) {
        image = [UIImage imageNamed:@"NoneIcon"];
    } else {
        image = [UIImage imageNamed:checked.boolValue ? @"TrueIcon" : @"FalseIcon"];
    }
    self.checkImageView.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.checkImageView sizeToFit];

    self.notesLabel.text = notes;

    [self setNeedsLayout];
}

- (CGSize)sizeThatFits:(CGSize)size {
    size.height = MAX(CGRectGetHeight(self.checkImageView.bounds), CGRectGetHeight(self.textLabel.bounds))
        + CHECK_ROW_NOTES_MARGIN
        + [self.notesLabel heightForWidth:size.width];
    return size;
}


@end