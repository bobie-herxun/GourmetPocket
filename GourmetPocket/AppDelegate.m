//
//  AppDelegate.m
//  GourmetPocket
//
//  Created by Bobie on 1/8/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "AppDelegate.h"

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
    self.window.rootViewController = self.viewController;
    
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
    
    [LQSession application:application didFinishLaunchingWithOptions:launchOptions];
    
    sleep(3);
    
    [self.window makeKeyAndVisible];
    return YES;
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

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [LQSession handlePush:userInfo];
}

@end
