#import "BPProductInfoViewController.h"
#import "BPProduct.h"
#import "BPProductInfoView.h"
#import "Objection.h"
#import "BPProductInfoDataSource.h"


@interface BPProductInfoViewController ()

@property(nonatomic, readonly) BPProductInfoDataSource *dataSource;
@end


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

    UITableView *tableView = self.castView.tableView;

    _dataSource = [[BPProductInfoDataSource alloc] initWithProduct:self.product tableView:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self.dataSource;
}

#pragma mark - Helpers

- (BPProductInfoView *)castView {
    return (BPProductInfoView *) self.view;
}

@end