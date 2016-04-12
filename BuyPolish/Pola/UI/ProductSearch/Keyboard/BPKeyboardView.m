#import "BPKeyboardView.h"

@implementation BPKeyboardView

- (void)awakeFromNib {
    [super awakeFromNib];

    self.backgroundColor = [UIColor clearColor];
}

- (IBAction)numberButtonAction:(UIButton *)sender {
    NSInteger number = sender.tag;
    [self.delegate keyboardView:self tappedNumber:number];
}

- (IBAction)confirmButtonAction:(UIButton *)sender {
    [self.delegate confirmButtonTappedInKeyboardView:self];
}

@end
