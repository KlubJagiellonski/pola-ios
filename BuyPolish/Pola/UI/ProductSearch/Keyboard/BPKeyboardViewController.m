#import "BPKeyboardViewController.h"
#import "BPKeyboardView.h"

@interface BPKeyboardViewController ()

@property (nonatomic) IBOutlet BPKeyboardView *keyboardView;

@end

@implementation BPKeyboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
}

- (BOOL)isPresented {
    return self.view.superview != nil;
}

@end
