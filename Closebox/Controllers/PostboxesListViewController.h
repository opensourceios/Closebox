@import UIKit;

@class Postbox;
@protocol PostboxesListViewControllerDelegate;

@interface PostboxesListViewController : UITableViewController

@property (nonatomic, weak) id<PostboxesListViewControllerDelegate> delegate;

- (void)showPostboxes:(NSArray *)postboxes;

@end

@protocol PostboxesListViewControllerDelegate <NSObject>

- (void)postboxesListViewController:(PostboxesListViewController *)postboxesListViewController didSelectPostbox:(Postbox *)postbox;

- (void)postboxesListViewController:(PostboxesListViewController *)postboxesListViewController didSelectPostboxFromAccessoryButton:(Postbox *)postbox;

@end
