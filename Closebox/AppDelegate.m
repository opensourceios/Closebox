#import "AppDelegate.h"

#import "ApplicationController.h"

@interface AppDelegate ()

@property (nonatomic, strong) ApplicationController *applicationController;

@end

@implementation AppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.tintColor = [UIColor redColor];
    self.applicationController = [[ApplicationController alloc] init];
    self.window.rootViewController = [self.applicationController initialViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
