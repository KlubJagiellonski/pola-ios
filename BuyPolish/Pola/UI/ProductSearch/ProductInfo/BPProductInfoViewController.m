#import "BPProductInfoViewController.h"
#import "BPProductResult.h"
#import "BPProductInfoView.h"
#import "Objection.h"
#import "BPProductInfoDataSource.h"
#import "BPProductManager.h"
#import "UIAlertView+BPUtilities.h"


@interface BPProductInfoViewController ()

@property(nonatomic, readonly) BPProductInfoDataSource *dataSource;
@property(nonatomic, readonly) BPProductManager *productManager;

@end


@implementation BPProductInfoViewController

objection_initializer_sel(@selector(initWithProduct:))
objection_requires_sel(@selector(productManager))

- (instancetype)initWithProduct:(BPProductResult *)product {
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

    self.title = self.product.barcode;

    UITableView *tableView = self.castView.tableView;

    _dataSource = [[BPProductInfoDataSource alloc] initWithProduct:self.product tableView:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self.dataSource;

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    weakify();
    [self.productManager retrieveProductWithBarcode:self.product.barcode completion:^(BPProductResult *product, NSError *error) {
        strongify()

        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

        if(!error) {
            strongSelf->_product = product;
            [strongSelf->_dataSource updateProduct:product];
        } else {
            [UIAlertView showErrorAlert:NSLocalizedString(@"Cannot fetch product info from server. Please try again.", @"")];
        }
    } completionQueue:[NSOperationQueue mainQueue]];
}

#pragma mark - Helpers

- (BPProductInfoView *)castView {
    return (BPProductInfoView *) self.view;
}

@end