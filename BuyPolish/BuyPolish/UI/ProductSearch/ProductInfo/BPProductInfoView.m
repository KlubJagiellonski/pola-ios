#import "BPProductInfoView.h"


@implementation BPProductInfoView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self addSubview:_tableView];
    }

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
}


@end