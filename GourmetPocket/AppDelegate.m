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
#import "MainViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)dealloc
{
    [_window release];
    //[_viewController release];
    [_mainViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
//    // Override point for customization after application launch.
//    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
//    
//    UINavigationController* navController =
//    [[UINavigationController alloc] initWithRootViewController:self.viewController];
//    
//    navController.navigationBar.barStyle = UIBarStyleBlack;
//    navController.navigationBar.backItem.title = @"Home";
//    self.window.rootViewController = navController;
//    navController.title = @"GourmetPocket";
    
    [LQSession setAPIKey:LQ_APIKey];

    [LQSession sessionWithAccessToken:LQ_API_TOKEN];
/*
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
 */
    
    // You may wish to listen for the notification the SDK sends when a user has logged in successfully
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authenticationDidSucceed:)
                                                 name:LQTrackerLocationChangedNotification
                                               object:nil];
    
    [LQSession application:application didFinishLaunchingWithOptions:launchOptions];
    
    self.mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    //sleep(2);
    
//    [self.window makeKeyAndVisible];
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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"GeoloqiData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"GeoloqiData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Additional methods for core-data
// - (NSURL*)applicationDocumentsDirectory
// - (void)saveContext
- (NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)saveContext
{
    NSError* error = nil;
    
    NSManagedObjectContext* managedObjectContext = [self managedObjectContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        abort();
    }
}

#pragma mark - 
+ (void)registerForPushNotificationsIfNotYetRegistered {
	if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasRegisteredForPushNotifications"]){
        [LQSession registerForPushNotificationsWithCallback:^(NSData *deviceToken, NSError *error) {
            if(error){
                NSLog(@"Failed to register for push tokens: %@", error);
            } else {
                NSLog(@"Got a push token! %@", deviceToken);
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasRegisteredForPushNotifications"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }];
	}
}

@end
