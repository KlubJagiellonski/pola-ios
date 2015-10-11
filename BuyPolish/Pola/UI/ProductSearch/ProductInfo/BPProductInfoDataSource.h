#import <Foundation/Foundation.h>


@class BPProductResult;


@interface BPProductInfoDataSource : NSObject <UITableViewDataSource>

@property(nonatomic, readonly) BPProductResult *product;

- (instancetype)initWithProduct:(BPProductResult *)product tableView:(UITableView *)tableView;

- (void)updateProduct:(BPProductResult *)product;
@end


@interface BPProductInfoDataSourceSection : NSObject

@property(nonatomic, readonly) NSString *title;
@property(nonatomic, readonly) NSArray *items;

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items;
+ (instancetype)sectionWithTitle:(NSString *)title items:(NSArray *)items;

@end