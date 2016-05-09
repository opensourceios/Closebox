@import MapKit;

@class Postbox;
@protocol PostboxesMapViewControllerDelegate;

@interface PostboxesMapViewController : UIViewController

@property (nonatomic, weak) id<PostboxesMapViewControllerDelegate> delegate;
@property (nonatomic, strong) MKMapView *mapView;

- (void)showPostboxes:(NSArray *)postboxes;
- (void)selectPostbox:(Postbox *)postbox;

@end

@protocol PostboxesMapViewControllerDelegate <NSObject>

- (void)postboxesMapViewController:(PostboxesMapViewController *)postboxesMapViewController didSelectPostbox:(Postbox *)postbox;
- (void)postboxesMapViewController:(PostboxesMapViewController *)postboxesMapViewController didUpdateUserLocation:(MKUserLocation *)userLocation;

@end
