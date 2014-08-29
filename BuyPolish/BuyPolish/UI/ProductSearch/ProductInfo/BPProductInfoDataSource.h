#import <Foundation/Foundation.h>


@class BPProduct;


@interface BPProductInfoDataSource : NSObject <UITableViewDataSource>

@property(nonatomic, readonly) BPProduct *product;

- (instancetype)initWithProduct:(BPProduct *)product tableView:(UITableView *)tableView;

@end


@interface BPProductInfoDataSourceSection : NSObject

@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSArray *items;

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items;
+ (instancetype)sectionWithTitle:(NSString *)title items:(NSArray *)items;

@end