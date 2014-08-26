#import "BPProductInfoViewController.h"
#import "BPProduct.h"
#import "BPProductInfoView.h"
#import "Objection.h"


@implementation BPProductInfoViewController

objection_initializer_sel(@selector(initWithProduct:))

- (instancetype)initWithProduct:(BPProduct *)product {
    self = [super init];
    if(self) {
        _product = product;
    }
    return self;
}

- (void)loadView {
    self.view = [[BPProductInfoView alloc] initWithFrame:CGRectZero];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.product.name;
}

@end