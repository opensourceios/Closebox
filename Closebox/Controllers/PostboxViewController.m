#import "PostboxViewController.h"

#import "ArrayTableViewDataSource.h"
#import "Postbox.h"
#import "Value1Cell.h"

static NSString * const Value1CellReuseIdentifier = @"Value1Cell";

@interface PostboxViewController ()

@property (nonatomic, strong) ArrayTableViewDataSource *tableViewDataSource;

@end

@implementation PostboxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[Value1Cell class] forCellReuseIdentifier:Value1CellReuseIdentifier];
    self.tableViewDataSource = [[ArrayTableViewDataSource alloc] initWithArray:[self postboxToArray]
                                                              cellReuseIdentifier:Value1CellReuseIdentifier
                                                               configureCellBlock:^(Value1Cell *cell, NSDictionary *postboxDetails) {
                                                                   cell.selectionStyle = UITableViewCellSelectionStyleNone;
                                                                   cell.textLabel.text = NSLocalizedString([postboxDetails allKeys][0], nil);
                                                                   cell.detailTextLabel.text = [postboxDetails allValues][0];
                                                               }];
    self.tableView.dataSource = self.tableViewDataSource;
}

- (NSArray *)postboxToArray {
    MKDistanceFormatter *distanceFormatter = [[MKDistanceFormatter alloc] init];
    NSString *distance = [distanceFormatter stringFromDistance:self.postbox.distance];
    
    return @[@{ @"address" : self.postbox.title }, @{ @"distance" : distance }, @{ @"weekday" : self.postbox.lastWeekday }, @{ @"saturday" : self.postbox.lastSaturday }];
}

@end
