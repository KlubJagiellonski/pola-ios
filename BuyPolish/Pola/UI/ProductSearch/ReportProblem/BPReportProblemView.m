//
// Created by Paweł Janeczek on 16/10/15.
// Copyright (c) 2015 PJMS. All rights reserved.
//

#import "BPReportProblemView.h"
#import "BPImageContainerView.h"
#import "UITextView+Placeholder.h"
#import "UIColor+BPAdditions.h"
#import "UIImage+KVNImageEffects.h"
#import "BPTheme.h"
#import "UILabel+BPAdditions.h"
#import "UIApplication+BPStatusBarHeight.h"

const int REPORT_PADDING = 16;
const int VERTICAL_MARGIN = 25;
const int SEND_BUTTON_HEIGHT = 30;
const int REPORT_TITLE_MARGIN = 10;
const int REPORT_DESCRIPTIONSHADOW_HEIGHT = 1;

@interface BPReportProblemView ()
@property(nonatomic, readonly) UILabel *titleLabel;
@property(nonatomic, readonly) UILabel *photoTitleLable;
@property(nonatomic, readonly) UILabel *descriptionTitleLabel;
@property(nonatomic) CGFloat bottomMargin;
@property(nonatomic, readonly) UIView *descriptionBottomShadowView;
@property(nonatomic, readonly) UILabel *helpLabel;
@end

@implementation BPReportProblemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [BPTheme mediumBackgroundColor];

        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [BPTheme titleFont];
        _titleLabel.textColor = [BPTheme defaultTextColor];
        _titleLabel.text = NSLocalizedString(@"Report", @"Report");
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];

        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[[UIImage imageNamed:@"CloseIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _closeButton.tintColor = [BPTheme defaultTextColor];
        [_closeButton sizeToFit];
        [self addSubview:_closeButton];

        _helpLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _helpLabel.font = [BPTheme normalFont];
        _helpLabel.textColor = [BPTheme defaultTextColor];
        _helpLabel.text = NSLocalizedString(@"Report help", @"Zrób zdjęcie kodu kreskowego i etykiety z danymi producenta");
        _helpLabel.numberOfLines = 0;
        [_helpLabel sizeToFit];
        [self addSubview:_helpLabel];

        _photoTitleLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _photoTitleLable.font = [BPTheme normalFont];
        _photoTitleLable.textColor = [BPTheme defaultTextColor];
        _photoTitleLable.text = NSLocalizedString(@"photos:", @"photos:");
        [_photoTitleLable sizeToFit];
        [self addSubview:_photoTitleLable];

        _imageContainerView = [[BPImageContainerView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageContainerView];

        _descriptionTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionTitleLabel.font = [BPTheme normalFont];
        _descriptionTitleLabel.textColor = [BPTheme defaultTextColor];
        _descriptionTitleLabel.text = NSLocalizedString(@"description (optional):", @"description (optional):");
        [_descriptionTitleLabel sizeToFit];
        [self addSubview:_descriptionTitleLabel];

        _descriptionTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        _descriptionTextView.textContainerInset = UIEdgeInsetsMake(10, 5, 10, 5);
        _descriptionTextView.backgroundColor = [UIColor whiteColor];
        _descriptionTextView.font = [BPTheme normalFont];
        _descriptionTextView.textColor = [BPTheme defaultTextColor];
        _descriptionTextView.placeholder = NSLocalizedString(@"Additional info", @"Additional info");
        _descriptionTextView.placeholderLabel.font = _descriptionTextView.font;
        _descriptionTextView.placeholderColor = [UIColor colorWithHexString:@"C3C3C3"];
        [self addSubview:_descriptionTextView];

        _descriptionBottomShadowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, REPORT_DESCRIPTIONSHADOW_HEIGHT)];
        _descriptionBottomShadowView.backgroundColor = [UIColor colorWithHexString:@"C3C3C3"];
        [self addSubview:_descriptionBottomShadowView];

        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.titleLabel.font = [BPTheme buttonFont];
        [_sendButton setTitle:[NSLocalizedString(@"Send", @"Send") uppercaseString] forState:UIControlStateNormal];
        [_sendButton setBackgroundImage:[BPUtilities imageWithColor:[BPTheme actionColor]] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_sendButton];

    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    CGRect rect = self.closeButton.frame;
    rect.origin.x = CGRectGetWidth(self.bounds) - REPORT_PADDING - CGRectGetWidth(rect);
    rect.origin.y = [UIApplication statusBarHeight] + REPORT_PADDING - self.bottomMargin;
    self.closeButton.frame = rect;

    rect = self.titleLabel.frame;
    rect.origin.x = REPORT_PADDING;
    rect.origin.y = (CGRectGetMinY(self.closeButton.frame) + CGRectGetHeight(self.closeButton.frame) / 2) - CGRectGetHeight(rect) / 2;
    self.titleLabel.frame = rect;

    rect = self.helpLabel.frame;
    rect.size.width = CGRectGetWidth(self.bounds) - 2 * REPORT_PADDING;
    rect.size.height = [self.helpLabel heightForWidth:rect.size.width];
    rect.origin.x = REPORT_PADDING;
    rect.origin.y = CGRectGetMaxY(self.closeButton.frame) + VERTICAL_MARGIN;
    self.helpLabel.frame = rect;

    rect = self.photoTitleLable.frame;
    rect.origin.x = REPORT_PADDING;
    rect.origin.y = CGRectGetMaxY(self.helpLabel.frame) + VERTICAL_MARGIN;
    self.photoTitleLable.frame = rect;

    rect.size = [self.imageContainerView sizeThatFits:CGSizeMake(CGRectGetWidth(self.bounds) - 2 * REPORT_PADDING, 0)];
    rect.origin.x = REPORT_PADDING;
    rect.origin.y = CGRectGetMaxY(self.photoTitleLable.frame) + REPORT_TITLE_MARGIN;
    self.imageContainerView.frame = rect;

    rect = self.descriptionTitleLabel.frame;
    rect.origin.x = REPORT_PADDING;
    rect.origin.y = MAX(CGRectGetMaxY(self.imageContainerView.frame) + VERTICAL_MARGIN - self.bottomMargin, REPORT_PADDING + [UIApplication statusBarHeight]);
    self.descriptionTitleLabel.frame = rect;

    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) - 2 * REPORT_PADDING, SEND_BUTTON_HEIGHT);
    rect.origin.x = REPORT_PADDING;
    rect.origin.y = CGRectGetHeight(self.bounds) - REPORT_PADDING - CGRectGetHeight(rect) - self.bottomMargin;
    self.sendButton.frame = rect;

    rect.size = CGSizeMake(CGRectGetWidth(self.bounds) - 2 * REPORT_PADDING, CGRectGetMinY(self.sendButton.frame) - VERTICAL_MARGIN - CGRectGetMaxY(self.descriptionTitleLabel.frame));
    rect.origin.x = REPORT_PADDING;
    rect.origin.y = CGRectGetMaxY(self.descriptionTitleLabel.frame) + REPORT_TITLE_MARGIN;
    self.descriptionTextView.frame = rect;

    rect.size = CGSizeMake(CGRectGetWidth(self.descriptionTextView.bounds), CGRectGetHeight(self.descriptionBottomShadowView.bounds));
    rect.origin.x = CGRectGetMinX(self.descriptionTextView.frame);
    rect.origin.y = CGRectGetMaxY(self.descriptionTextView.frame);
    self.descriptionBottomShadowView.frame = rect;
}

- (void)keyboardWillShowWithHeight:(CGFloat)height duration:(double)duration curve:(NSUInteger)curve {
    self.bottomMargin = height;

    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:nil];
}

- (void)keyboardWillHideWithDuration:(double)duration curve:(NSUInteger)curve {
    self.bottomMargin = 0;
    [UIView animateWithDuration:duration delay:0 options:curve animations:^{
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:nil];
}

@end