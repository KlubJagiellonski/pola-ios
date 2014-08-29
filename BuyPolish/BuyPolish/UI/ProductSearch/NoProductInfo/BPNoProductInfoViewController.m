#import "BPNoProductInfoViewController.h"
#import "BPNoProductInfoView.h"


@implementation BPNoProductInfoViewController

- (void)loadView {
    self.view = [[BPNoProductInfoView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"No info", @"No info");
}

@end