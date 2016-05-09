#import "PostboxesListViewController.h"

#import "ArrayTableViewDataSource.h"
#import "Postbox.h"
#import "SubtitleCell.h"

static NSString * const SubtitleCellReuseIdentifier = @"SubtitleCell";

@interface PostboxesListViewController ()

@property (nonatomic, strong) ArrayTableViewDataSource *tableViewDataSource;
@property (nonatomic, strong) MKDistanceFormatter *distanceFormatter;
@end

@implementation PostboxesListViewController

- (MKDistanceFormatter *)distanceFormatter {
    if (!_distanceFormatter) {
        _distanceFormatter = [[MKDistanceFormatter alloc] init];
    }
    
    return _distanceFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[SubtitleCell class] forCellReuseIdentifier:SubtitleCellReuseIdentifier];
}

- (void)showPostboxes:(NSArray *)postboxes {
    self.tableViewDataSource = [[ArrayTableViewDataSource alloc] initWithArray:postboxes
                                                              cellReuseIdentifier:SubtitleCellReuseIdentifier
                                                               configureCellBlock:^(SubtitleCell *cell, Postbox *postbox) {
                                                                   cell.textLabel.text = postbox.title;
                                                                   cell.detailTextLabel.text = [self.distanceFormatter stringFromDistance:postbox.distance];
                                                                   cell.accessoryType = UITableViewCellAccessoryDetailButton;
                                                               }];
    self.tableView.dataSource = self.tableViewDataSource;
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Postbox *postbox = [self.tableViewDataSource itemAtIndexPath:indexPath];
    [self.delegate postboxesListViewController:self didSelectPostbox:postbox];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    Postbox *postbox = [self.tableViewDataSource itemAtIndexPath:indexPath];
    [self.delegate postboxesListViewController:self didSelectPostboxFromAccessoryButton:postbox];
}

@end
