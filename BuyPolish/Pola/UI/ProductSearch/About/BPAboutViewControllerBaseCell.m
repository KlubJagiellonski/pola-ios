#import "BPAboutViewControllerBaseCell.h"
#import "BPTheme.h"

CGFloat const kAboutCellWhiteBackgroundHorizontalMargin = 16.0f;
CGFloat const kAboutCellWhiteBackgroundVerticalMargin = 8.0f;

@implementation BPAboutViewControllerBaseCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Set background color
        self.contentView.backgroundColor = [BPTheme mediumBackgroundColor];
    }
    return self;
}

@end
