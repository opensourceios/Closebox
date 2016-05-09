@import MapKit;

@interface Postbox : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *lastWeekday;
@property (nonatomic, copy) NSString *lastSaturday;
@property (nonatomic) CLLocationDistance distance;
@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
