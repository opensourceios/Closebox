@import CoreLocation;

@class Postbox;

@interface PostboxesRepository : NSObject

- (NSArray *)postboxesNearLocation:(CLLocationCoordinate2D)location;

@end
