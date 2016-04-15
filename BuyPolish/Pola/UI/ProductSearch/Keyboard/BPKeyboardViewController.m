#import "BPKeyboardViewController.h"
#import "BPKeyboardView.h"
#import "BPKeyboardTextView.h"

@interface BPKeyboardViewController () <BPKeyboardViewDelegate>

@property (nonatomic) IBOutlet BPKeyboardView *keyboardView;
@property (nonatomic) IBOutlet BPKeyboardTextView *textView;

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
    [self.textView insertValue:number];
}

- (void)confirmButtonTappedInKeyboardView:(BPKeyboardView *)keyboardView {

}

@end
