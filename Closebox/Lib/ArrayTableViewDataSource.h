@import UIKit;

typedef void (^ArrayTableViewDataSourceCellConfigureBlock)(id cell, id item);

@interface ArrayTableViewDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithArray:(NSArray *)array cellReuseIdentifier:(NSString *)cellReuseIdentifier configureCellBlock:(ArrayTableViewDataSourceCellConfigureBlock)configureCellBlock;
- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
