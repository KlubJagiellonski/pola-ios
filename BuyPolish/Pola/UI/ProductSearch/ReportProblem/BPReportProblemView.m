//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPReportProblemView.h"
#import "BPImageContainerView.h"
#import "UITextView+Placeholder.h"
#import "BPConst.h"

const int PADDING = 16;
const int VERTICAL_MARGIN = 30;
const int SEND_BUTTON_HEIGHT = 50;

@interface BPReportProblemView ()
@property(nonatomic, readonly) UILabel *titleLabel;
@property(nonatomic, readonly) UILabel *photoTitleLable;
@property(nonatomic, readonly) UILabel *descriptionTitleLabel;
@end

@implementation BPReportProblemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = NSLocalizedString(@"Report", @"Report");
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];

        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [_closeButton sizeToFit];
        [self addSubview:_closeButton];

        _photoTitleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _photoTitleLable.text = NSLocalizedString(@"photos:", @"photos:");
        [_photoTitleLable sizeToFit];
        [self addSubview:_photoTitleLable];

        _imageContainerView = [[BPImageContainerView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageContainerView];

        _descriptionTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionTitleLabel.text = NSLocalizedString(@"description (optional):", @"description (optional):");
        [_descriptionTitleLabel sizeToFit];
        [self addSubview:_descriptionTitleLabel];

        _descriptionTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _descriptionTextView.backgroundColor = [UIColor whiteColor];
        _descriptionTextView.placeholder = NSLocalizedString(@"Additional info", @"Additional info");
        _descriptionTextView.placeholderColor = [self backgroundColor];
        [self addSubview:_descriptionTextView];

        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:NSLocalizedString(@"Send", @"Send") forState:UIControlStateNormal];
        _sendButton.backgroundColor = [UIColor redColor];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_sendButton];

    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.closeButton.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - PADDING - CGRectGetWidth(rect);
    rect.origin.y = STATUS_BAR_HEIGHT + PADDING;
    self.closeButton.frame = rect;

    rect = self.titleLabel.frame;
    rect.origin.x = PADDING;
    rect.origin.y = (CGRectGetMinY(self.closeButton.frame) + CGRectGetHeight(self.closeButton.frame) / 2) - CGRectGetHeight(rect) / 2;
    self.titleLabel.frame = rect;

    rect = self.photoTitleLable.frame;
    rect.origin.x = PADDING;
    rect.origin.y = CGRectGetMaxY(self.closeButton.frame) + VERTICAL_MARGIN;
    self.photoTitleLable.frame = rect;

    rect.size = [self.imageContainerView sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds) - 2 * PADDING, 0)];
    rect.origin.x = PADDING;
    rect.origin.y = CGRectGetMaxY(self.photoTitleLable.frame);
    self.imageContainerView.frame = rect;

    rect = self.descriptionTitleLabel.frame;
    rect.origin.x = PADDING;
    rect.origin.y = CGRectGetMaxY(self.imageContainerView.frame) + VERTICAL_MARGIN;
    self.descriptionTitleLabel.frame = rect;

    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) - 2 * PADDING, SEND_BUTTON_HEIGHT);
    rect.origin.x = PADDING;
    rect.origin.y = CGRectGetHeight(self.bounds) - PADDING - CGRectGetHeight(rect);
    self.sendButton.frame = rect;

    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) - 2 * PADDING, CGRectGetMinY(self.sendButton.frame) - VERTICAL_MARGIN - CGRectGetMaxY(self.descriptionTitleLabel.frame));
    rect.origin.x = PADDING;
    rect.origin.y = CGRectGetMaxY(self.descriptionTitleLabel.frame);
    self.descriptionTextView.frame = rect;
}

@end