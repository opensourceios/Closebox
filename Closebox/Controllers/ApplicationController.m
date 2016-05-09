#import "ApplicationController.h"

#import "Postbox.h"
#import "PostboxesRepository.h"
#import "PostboxViewController.h"
#import "PostboxesListViewController.h"
#import "PostboxesMapViewController.h"
#import "SegmentedViewController.h"

@interface ApplicationController () <PostboxesListViewControllerDelegate, SegmentedViewControllerDelegate, PostboxesMapViewControllerDelegate>

@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) SegmentedViewController *segmentedViewController;
@property (nonatomic, strong) PostboxesMapViewController *postboxesMapViewController;
@property (nonatomic, strong) PostboxesListViewController *postboxesListViewController;
@property (nonatomic, strong) PostboxesRepository *repository;
@property (nonatomic, copy) CLLocation *userLocation;

@end

@implementation ApplicationController

- (instancetype)init {
    self = [super init];
    if (self) {
        _repository = [[PostboxesRepository alloc] init];
    }

    return self;
}

- (UIViewController *)initialViewController {
    self.postboxesMapViewController = [[PostboxesMapViewController alloc] init];
    self.postboxesMapViewController.title = NSLocalizedString(@"Map", nil);
    self.postboxesMapViewController.delegate = self;

    self.postboxesListViewController = [[PostboxesListViewController alloc] init];
    self.postboxesListViewController.title = NSLocalizedString(@"List", nil);
    self.postboxesListViewController.delegate = self;

    self.segmentedViewController = [[SegmentedViewController alloc] init];
    self.segmentedViewController.viewControllers = @[self.postboxesMapViewController, self.postboxesListViewController];
    self.segmentedViewController.title = NSLocalizedString(@"Postboxes", nil);
    self.segmentedViewController.delegate = self;

    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.segmentedViewController];
    return self.navigationController;
}

#pragma mark - PostboxesListViewControllerDelegate

- (void)postboxesListViewController:(PostboxesListViewController *)postboxesListViewController didSelectPostbox:(Postbox *)postbox {
    [self.segmentedViewController selectSegmentAtIndex:0];
    [self.postboxesMapViewController selectPostbox:postbox];
}

- (void)postboxesListViewController:(PostboxesListViewController *)postboxesListViewController didSelectPostboxFromAccessoryButton:(Postbox *)postbox {
    [self showPostbox:postbox];
}

#pragma mark - PostboxesMapViewControllerDelegate

- (void)postboxesMapViewController:(PostboxesMapViewController *)postboxesMapViewController didSelectPostbox:(Postbox *)postbox {
    [self showPostbox:postbox];
}

- (void)postboxesMapViewController:(PostboxesMapViewController *)postboxesMapViewController didUpdateUserLocation:(MKUserLocation *)userLocation {
    if (self.userLocation) {
        if ([self.userLocation distanceFromLocation:[userLocation location]] < 100) {
            self.userLocation = [userLocation location];
            return;
        }
    }

    self.userLocation = [userLocation location];
    [self showPostboxesNearLocation:userLocation.coordinate];
}

#pragma mark - SegmentedViewControllerDelegate

- (void)segmentedViewController:(SegmentedViewController *)segmentedViewController willShowViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[PostboxesMapViewController class]]) {
        UIImage *pinImage = [UIImage imageNamed:@"Pin"];
        UIBarButtonItem *findPostboxesNearMapCentreBarButtonItem = [[UIBarButtonItem alloc] initWithImage:pinImage
                                                                                                    style:UIBarButtonItemStyleBordered
                                                                                                   target:self
                                                                                                   action:@selector(findPostboxesNearMapCentre)];
        self.segmentedViewController.navigationItem.leftBarButtonItem = findPostboxesNearMapCentreBarButtonItem;
        UIBarButtonItem *findPostboxesNearUserLocationBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                              target:self
                                                                                              action:@selector(findPostboxesNearUserLocation)];
        self.segmentedViewController.navigationItem.rightBarButtonItem = findPostboxesNearUserLocationBarButtonItem;
    } else {
        self.segmentedViewController.navigationItem.leftBarButtonItem = nil;
        self.segmentedViewController.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - Private

- (void)findPostboxesNearMapCentre {
    PostboxesMapViewController *mapViewController = self.postboxesMapViewController;
    CLLocationCoordinate2D centerCoordinate = mapViewController.mapView.centerCoordinate;
    [self showPostboxesNearLocation:centerCoordinate];
}

- (void)findPostboxesNearUserLocation {
    PostboxesMapViewController *mapViewController = self.postboxesMapViewController;
    CLLocationCoordinate2D userLocationCoordinate = mapViewController.mapView.userLocation.coordinate;
    [self showPostboxesNearLocation:userLocationCoordinate];
}

- (void)showPostboxesNearLocation:(CLLocationCoordinate2D)location {
    NSArray *postboxes = [self.repository postboxesNearLocation:location];
    if ([postboxes count] > 0) {
        [self.postboxesMapViewController showPostboxes:postboxes];
        [self.postboxesListViewController showPostboxes:postboxes];
    } else {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Closebox", nil)
                                    message:NSLocalizedString(@"Sorry, there are no postboxes nearby", nil)
                                   delegate:self
                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                          otherButtonTitles:nil] show];
    }
}

- (void)showPostbox:(Postbox *)postbox {
    PostboxViewController *postboxViewController = [[PostboxViewController alloc] initWithStyle:UITableViewStyleGrouped];
    postboxViewController.postbox = postbox;
    [self.navigationController pushViewController:postboxViewController animated:YES];
}

@end
