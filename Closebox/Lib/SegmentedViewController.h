@import UIKit;

@protocol SegmentedViewControllerDelegate;

@interface SegmentedViewController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, weak) id<SegmentedViewControllerDelegate> delegate;

- (void)selectSegmentAtIndex:(NSInteger)index;

@end

@protocol SegmentedViewControllerDelegate <NSObject>

@optional

- (void)segmentedViewController:(SegmentedViewController *)segmentedViewController willShowViewController:(UIViewController *)viewController;
- (void)segmentedViewController:(SegmentedViewController *)segmentedViewController willHideViewController:(UIViewController *)viewController;

@end
