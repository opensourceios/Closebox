#import "PostboxesMapViewController.h"

#import "Postbox.h"

@interface PostboxesMapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) NSArray *postboxes;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation PostboxesMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }

    self.mapView = [[MKMapView alloc] init];
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    [self.view addSubview:self.mapView];
    MKMapView *mapView = self.mapView;
    NSDictionary *views = NSDictionaryOfVariableBindings(mapView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[mapView]|" options:(NSLayoutFormatOptions)0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapView]|" options:(NSLayoutFormatOptions)0 metrics:nil views:views]];
}

- (void)showPostboxes:(NSArray *)postboxes {
    self.postboxes = postboxes;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        [self.mapView removeAnnotation:annotation];
    }
    
    [self.mapView addAnnotations:postboxes];
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations) {
        if ([annotation isKindOfClass:[MKUserLocation class]]) {
            continue;
        }
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [self.mapView setVisibleMapRect:zoomRect animated:NO];
    [self.mapView selectAnnotation:self.postboxes[0] animated:YES];
}

- (void)selectPostbox:(Postbox *)postbox {
    [self.mapView selectAnnotation:postbox animated:YES];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
    if ([annotation isKindOfClass:[Postbox class]]) {
        static NSString * const postboxIdentifier = @"Postbox";
        
        MKPinAnnotationView *postboxAnnotationView = (MKPinAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:postboxIdentifier];
        if (postboxAnnotationView == nil) {
            postboxAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:postboxIdentifier];
        } else {
            postboxAnnotationView.annotation = annotation;
        }
        
        postboxAnnotationView.enabled = YES;
        postboxAnnotationView.canShowCallout = YES;
        postboxAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        return postboxAnnotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    [self.delegate postboxesMapViewController:self didSelectPostbox:view.annotation];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    [self.delegate postboxesMapViewController:self didUpdateUserLocation:userLocation];
}

@end
