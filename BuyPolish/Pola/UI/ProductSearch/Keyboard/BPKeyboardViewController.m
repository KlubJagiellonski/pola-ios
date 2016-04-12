#import "BPKeyboardViewController.h"
#import "BPKeyboardView.h"

@interface BPKeyboardViewController () <BPKeyboardViewDelegate>

@property (nonatomic) IBOutlet BPKeyboardView *keyboardView;

@end

@implementation BPKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.keyboardView.delegate = self;

    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
}

- (BOOL)isPresented {
    return self.view.superview != nil;
}

#pragma mark - BPKeyboardViewDelegate

- (void)keyboardView:(BPKeyboardView *)keyboardView tappedNumber:(NSInteger)number {

}

- (void)confirmButtonTappedInKeyboardView:(BPKeyboardView *)keyboardView {

}

@end
