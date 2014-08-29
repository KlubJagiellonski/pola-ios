#import "BPProductInfoDataSource.h"
#import "BPProduct.h"
#import "BPIsPolishTableViewCell.h"


NSString *const BPProductInfoDataIsPolishIdentifier = @"BPProductInfoDataIsPolishIdentifier";
NSString *const BPProductInfoDataDefaultIdentifier = @"BPProductInfoDataDefaultIdentifier";


@interface BPProductInfoDataSource ()

@property(nonatomic, readonly) NSArray *data;
@property(nonatomic, readonly) UITableView *tableView;
@end


@implementation BPProductInfoDataSource

- (instancetype)initWithProduct:(BPProduct *)product tableView:(UITableView *)tableView{
    self = [super init];
    if(self) {
        _tableView = tableView;
        _product = product;
        [self initializeData];
    }
    return self;
}

- (void)initializeData {
    [self.tableView registerClass:[BPIsPolishTableViewCell class] forCellReuseIdentifier:BPProductInfoDataIsPolishIdentifier];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BPProductInfoDataDefaultIdentifier];

    _data = @[
        [BPProductInfoDataSourceSection sectionWithTitle:@"" items:@[
            NSStringFromSelector(@selector(handleIsPolishIndexPath:)),
        ]],
        [BPProductInfoDataSourceSection sectionWithTitle:NSLocalizedString(@"General Info", @"") items:@[
            NSStringFromSelector(@selector(handleProductNameIndexPath:)),
        ]],
    ];
}

#pragma mark - Cells

- (UITableViewCell *)handleIsPolishIndexPath:(NSIndexPath *)indexPath {
    BPIsPolishTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BPProductInfoDataIsPolishIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Is Polish", @"Is Polish");
    NSString *detailText;
    if(self.product.isChecked) {
        detailText = self.product.isPolish ? NSLocalizedString(@"Yes", @"Yes") : NSLocalizedString(@"No", @"No");
    } else {
        detailText = NSLocalizedString(@"Unkown", @"Unkown");
    }
    cell.detailTextLabel.text = detailText;
    return cell;
}

- (UITableViewCell *)handleProductNameIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BPProductInfoDataDefaultIdentifier forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(@"Name", @"Name");
    cell.detailTextLabel.text = self.product.name;
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