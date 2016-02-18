#import <UIKit/UIKit.h>

@class BPAboutRow;

extern CGFloat const kAboutCellWhiteBackgroundHorizontalMargin;
extern CGFloat const kAboutCellWhiteBackgroundVerticalMargin;

@interface BPAboutViewControllerBaseCell : UITableViewCell

@property (weak, nonatomic) BPAboutRow *aboutRowInfo;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
