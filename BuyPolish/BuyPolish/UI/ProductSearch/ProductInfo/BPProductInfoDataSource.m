#import "BPProductInfoDataSource.h"
#import "BPProduct.h"
#import "BPCompany.h"

NSString *const BPProductInfoDataDefaultIdentifier = @"BPProductInfoDataDefaultIdentifier";


@interface BPProductInfoDataSource ()

@property(nonatomic, readonly) NSArray *data;
@property(nonatomic, readonly) UITableView *tableView;
@end


@implementation BPProductInfoDataSource

- (instancetype)initWithProduct:(BPProduct *)product tableView:(UITableView *)tableView {
    self = [super init];
    if (self) {
        _tableView = tableView;
        _product = product;
        [self initializeData];
    }
    return self;
}

- (void)initializeData {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BPProductInfoDataDefaultIdentifier];

    _data = @[
        [BPProductInfoDataSourceSection sectionWithTitle:NSLocalizedString(@"Is polish", @"Is polish") items:@[
            NSStringFromSelector(@selector(handleMadeInPolandIndexPath:)),
            NSStringFromSelector(@selector(handleCapitalInPolandIndexPath:)),
            NSStringFromSelector(@selector(handleTaxesInPolandIndexPath:))
        ]],
        [BPProductInfoDataSourceSection sectionWithTitle:NSLocalizedString(@"Produt Info", @"Produt Info") items:@[
            NSStringFromSelector(@selector(handleProductNameIndexPath:)),
            NSStringFromSelector(@selector(handleBarcodeIndexPath:)),
        ]],
        [BPProductInfoDataSourceSection sectionWithTitle:NSLocalizedString(@"Company Info", @"Company Info") items:@[
            NSStringFromSelector(@selector(handleCompanyNameIndexPath:)),
            NSStringFromSelector(@selector(handleCompanyNipIndexPath:)),
            NSStringFromSelector(@selector(handleCompanyRegonIndexPath:)),
        ]],
    ];
}

#pragma mark - Cells

- (UITableViewCell *)handleProductNameIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BPProductInfoDataDefaultIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Name", @"Name");
    cell.detailTextLabel.text = self.product.name;
    return cell;
}

- (UITableViewCell *)handleBarcodeIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BPProductInfoDataDefaultIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Barcode", @"Barcode");
    cell.detailTextLabel.text = self.product.barcode;
    return cell;
}

- (UITableViewCell *)handleMadeInPolandIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BPProductInfoDataDefaultIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Made in Poland", @"Made in Poland");
    NSNumber *madeInPoland = self.product.madeInPoland;
    if (madeInPoland == nil) {
        madeInPoland = self.product.company.madeInPoland;
    }
    cell.detailTextLabel.text = [self percentageText:madeInPoland];
    return cell;
}

- (UITableViewCell *)handleCapitalInPolandIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BPProductInfoDataDefaultIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Capital in Poland", @"Capital in Poland");
    cell.detailTextLabel.text = [self percentageText:self.product.company.capitalInPoland];
    return cell;
}

- (UITableViewCell *)handleTaxesInPolandIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BPProductInfoDataDefaultIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Taxes in Poland", @"Taxes in Poland");
    cell.detailTextLabel.text = [self percentageText:self.product.company.taxesInPoland];
    return cell;
}

- (UITableViewCell *)handleCompanyNameIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BPProductInfoDataDefaultIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Name", @"Name");
    cell.detailTextLabel.text = self.product.company.name;
    return cell;
}

- (UITableViewCell *)handleCompanyNipIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BPProductInfoDataDefaultIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Nip", @"Nip");
    cell.detailTextLabel.text = self.product.company.nip;
    return cell;
}

- (UITableViewCell *)handleCompanyRegonIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BPProductInfoDataDefaultIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Regon", @"Regon");
    cell.detailTextLabel.text = self.product.company.regon;
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BPProductInfoDataSourceSection *dataSourceSection = self.data[(NSUInteger) section];
    return dataSourceSection.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BPProductInfoDataSourceSection *section = self.data[(NSUInteger) indexPath.section];
    NSString *selectorString = section.items[(NSUInteger) indexPath.row];
    SEL sel = NSSelectorFromString(selectorString);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [self performSelector:sel withObject:indexPath];
#pragma clang diagnostic pop
}

#pragma mark - Helpers

- (NSString *)percentageText:(NSNumber *)percentage {
    if (percentage == nil) {
        return NSLocalizedString(@"Unknown", @"Unknown");
    } else {
        return [NSString stringWithFormat:@"%i %%", percentage.intValue];
    }
}

@end


@implementation BPProductInfoDataSourceSection

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items {
    self = [super init];
    if (self) {
        _title = title;
        _items = items;
    }

    return self;
}

+ (instancetype)sectionWithTitle:(NSString *)title items:(NSArray *)items {
    return [[self alloc] initWithTitle:title items:items];
}

@end