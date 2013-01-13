//
//  AppDelegate.m
//  GourmetPocket
//
//  Created by Bobie on 1/8/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "AppDelegate.h"
#import "sqlite3.h"

// Geoloqi SDKs
#import "LQConfig.h"
#import "LQSession.h"
#import "LQTracker.h"

#import "ViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    
    UINavigationController* navController =
    [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    navController.navigationBar.barStyle = UIBarStyleBlack;
    navController.navigationBar.backItem.title = @"Home";
    self.window.rootViewController = navController;
    navController.title = @"GourmetPocket";
    
    [LQSession setAPIKey:LQ_APIKey];
    
    if ([LQSession savedSession])
    {
        // resume tracking in the previous state
        [LQTracker sharedTracker];
        // re-register for push-notificaton to tell the server that the user is still using the app
        [LQSession registerForPushNotificationsWithCallback:NULL];
    }
    else
    {
        [LQSession createAnonymousUserAccountWithUserInfo:nil completion:^(LQSession *session, NSError *error) {
            if(error) {
                NSLog(@"ERROR: Failed to create account: %@", error);
            } else {
                // Save the session to disk so it will be restored on next launch
                [LQSession setSavedSession:session];
                
                // Now register for push notifications
                // After the user approves, the app delegate method didRegisterForRemoteNotificationsWithDeviceToken will be called
                [LQSession registerForPushNotificationsWithCallback:^(NSData *deviceToken, NSError *error) {
                    if(error){
                        NSLog(@"Failed to register for push tokens: %@", error);
                    } else {
                        NSLog(@"Got a push token! %@", deviceToken);
                    }
                }];
                
                // Start tracking
                [[LQTracker sharedTracker] setProfile:LQTrackerProfileAdaptive];
                
                // Note: You may not want to start tracking right here, and you may not want to register for push notifications now either.
                // You are better off putting off these until you absolutely need to, since they will show a popup prompt to the user.
                // It is somewhat annoying to see two prompts in a row before even getting a chance to use the app, so you should wait
                // until you need to show a map or until the user turns "on" some functionality before prompting for location access
                // and push notification permission.
            }
        }];
    }
    
    // You may wish to listen for the notification the SDK sends when a user has logged in successfully
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authenticationDidSucceed:)
                                                 name:LQTrackerLocationChangedNotification
                                               object:nil];
    
    [LQSession application:application didFinishLaunchingWithOptions:launchOptions];
    
    sleep(2);
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)authenticationDidSucceed:(NSNotificationCenter *)notification
{
    // You can dismiss your login screen here, or have some other indication the login was successful
    // ...
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
{
    // For push notification support, we need to get the push token from UIApplication via this method.
    // If you like, you can be notified when the relevant web service call to the Geoloqi API succeeds.
    [LQSession registerDeviceToken:deviceToken withMode:LQPushNotificationModeDev];
    
    // When you're ready to publish your project to the app store, you should switch to "live" push mode.
    // [LQSession registerDeviceToken:deviceToken withMode:LQPushNotificationModeLive];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
{
    [LQSession handleDidFailToRegisterForRemoteNotifications:error];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [LQSession handlePush:userInfo];
}

#pragma mark - Geoloqi AppDelegate methods
+ (NSString *)cacheDatabasePathForCategory:(NSString *)category
{
	NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	return [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.lol.sqlite", category]];
}

// clears all rows from a table in a database
+ (void)deleteFromTable:(NSString *)collectionName forCategory:(NSString *)category
{
    sqlite3 *db;
    if(sqlite3_open([[AppDelegate cacheDatabasePathForCategory:category] UTF8String], &db) == SQLITE_OK) {
        NSString *sql = [NSString stringWithFormat:@"DELETE FROM '%@'", collectionName];
        sqlite3_exec(db, [sql UTF8String], NULL, NULL, NULL);
    }
}

@end
