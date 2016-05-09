#import "ArrayTableViewDataSource.h"

@interface ArrayTableViewDataSource ()

@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) NSString *cellReuseIdentifier;
@property (nonatomic, copy) ArrayTableViewDataSourceCellConfigureBlock configureCellBlock;

@end

@implementation ArrayTableViewDataSource

- (instancetype)initWithArray:(NSArray *)array cellReuseIdentifier:(NSString *)cellReuseIdentifier configureCellBlock:(ArrayTableViewDataSourceCellConfigureBlock)configureCellBlock {
    self = [super init];
    if (self) {
        self.array = array;
        self.cellReuseIdentifier = cellReuseIdentifier;
        self.configureCellBlock = [configureCellBlock copy];
    }

    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.array[indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellReuseIdentifier forIndexPath:indexPath];
    id item = [self itemAtIndexPath:indexPath];
    self.configureCellBlock(cell, item);
    
    return cell;
}

@end
