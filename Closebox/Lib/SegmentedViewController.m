#import "SegmentedViewController.h"

@interface SegmentedViewController ()

@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) UIViewController *currentViewController;

@end

@implementation SegmentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    NSArray *titles = [self.viewControllers valueForKey:@"title"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:titles];
    self.segmentedControl.selectedSegmentIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentedControlChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    [self showViewController:self.viewControllers[0]];
}

- (void)selectSegmentAtIndex:(NSInteger)index {
    self.segmentedControl.selectedSegmentIndex = index;
    [self segmentedControlChanged:nil];
}

- (void)segmentedControlChanged:(id)sender {
    [self hideViewController:self.currentViewController];
    UIViewController *viewController = self.viewControllers[self.segmentedControl.selectedSegmentIndex];
    [self showViewController:viewController];
}

- (void)showViewController:(UIViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(segmentedViewController:willShowViewController:)]) {
        [self.delegate segmentedViewController:self willShowViewController:viewController];
    }
    [self addChildViewController:viewController];
    viewController.view.frame = self.view.bounds;
    [self.view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
    self.currentViewController = viewController;
}

- (void)hideViewController:(UIViewController *)viewController {
    if ([self.delegate respondsToSelector:@selector(segmentedViewController:willHideViewController:)]) {
        [self.delegate segmentedViewController:self willHideViewController:viewController];
    }
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
    self.currentViewController = nil;
}

@end
