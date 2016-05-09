#import "PostboxesRepository.h"

#import "FMDatabase.h"
#import "Postbox.h"

@interface PostboxesRepository ()

@property (nonatomic, strong) FMDatabase *database;

@end

@implementation PostboxesRepository

- (void)dealloc {
    [_database close];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *databasePath = [[NSBundle mainBundle] pathForResource:@"postboxes" ofType:@"sqlite3"];
        _database = [FMDatabase databaseWithPath:databasePath];
        if (![_database open]) {
            abort();
        } else {
            sqlite3_create_function([_database sqliteHandle], "distance", 4, SQLITE_UTF8, NULL, &distanceFunc, NULL, NULL);
        }
    }

    return self;
}

- (NSArray *)postboxesNearLocation:(CLLocationCoordinate2D)location {
    NSMutableArray *postboxes = [[NSMutableArray alloc] initWithCapacity:20];
    NSString *query = @" \
    SELECT address1, latitude, longitude, weekday, saturday, distance(latitude, longitude, ?, ?) AS distance \
    FROM postboxes \
    WHERE abs(latitude - ?) < 0.3 AND abs(longitude - ?) < 0.3 \
    ORDER BY distance LIMIT 10 \
    ";
    NSNumber *latitude = [NSNumber numberWithDouble:location.latitude];
    NSNumber *longitude = [NSNumber numberWithDouble:location.longitude];
    NSArray *arguments = @[latitude, longitude, latitude, longitude];
    FMResultSet *resultSet = [self.database executeQuery:query withArgumentsInArray:arguments];
    while ([resultSet next]) {
        Postbox *postbox = [[Postbox alloc] init];
        postbox.title = [resultSet stringForColumn:@"address1"];
        postbox.coordinate = CLLocationCoordinate2DMake([resultSet doubleForColumn:@"latitude"], [resultSet doubleForColumn:@"longitude"]);
        postbox.lastWeekday = [resultSet stringForColumn:@"weekday"];
        postbox.lastSaturday = [resultSet stringForColumn:@"saturday"];
        postbox.distance = [resultSet doubleForColumn:@"distance"] * 1000; // in meters
        [postboxes addObject:postbox];
    }
    
    return postboxes;
}

#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180

static void distanceFunc(sqlite3_context *context, int argc, sqlite3_value **argv)
{
    // check that we have four arguments (lat1, lon1, lat2, lon2)
    assert(argc == 4);
    // check that all four arguments are non-null
    if (sqlite3_value_type(argv[0]) == SQLITE_NULL || sqlite3_value_type(argv[1]) == SQLITE_NULL || sqlite3_value_type(argv[2]) == SQLITE_NULL || sqlite3_value_type(argv[3]) == SQLITE_NULL) {
        sqlite3_result_null(context);
        return;
    }
    
    // get the four argument values
    double lat1 = sqlite3_value_double(argv[0]);
    double lon1 = sqlite3_value_double(argv[1]);
    double lat2 = sqlite3_value_double(argv[2]);
    double lon2 = sqlite3_value_double(argv[3]);
    // convert lat1 and lat2 into radians now, to avoid doing it twice below
    double lat1rad = DEG2RAD(lat1);
    double lat2rad = DEG2RAD(lat2);
    // apply the spherical law of cosines to our latitudes and longitudes, and set the result appropriately
    // 6378.1 is the approximate radius of the earth in kilometres
    sqlite3_result_double(context, acos(sin(lat1rad) * sin(lat2rad) + cos(lat1rad) * cos(lat2rad) * cos(DEG2RAD(lon2) - DEG2RAD(lon1))) * 6378.1);
}

@end
