#import <UIKit/UIKit.h>
#import "BPAboutFooterView.h"
#import "BPTheme.h"


@interface BPAboutFooterView ()

@property(nonnull, readonly) UILabel *infoLabel;

@end


@implementation BPAboutFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat horizontalMargin = 35;
        
        NSString *bundleVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
        NSString *bundleShortVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
        
        NSString *version = [NSString stringWithFormat:@"%@ (%@)", bundleShortVersion, bundleVersion];
        NSString *info = [NSString stringWithFormat:NSLocalizedString(@"About.Info", nil), version];
        
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.bounds.size.width - 2 * horizontalMargin, self.bounds.size.height)];
        self.infoLabel.font = [BPTheme normalFont];
        self.infoLabel.textColor = [BPTheme defaultTextColor];
        self.infoLabel.numberOfLines = 3;
        self.infoLabel.text = info;
        
        [self addSubview:self.infoLabel];
    }
    return self;
}

@end
