//
//  AppDelegate.h
//  GourmetPocket
//
//  Created by Bobie on 1/8/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class ViewController;
@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) MainViewController* mainViewController;


#pragma mark - Geoloqi AppDelegate methods
+ (NSString *)cacheDatabasePathForCategory:(NSString *)category;
+ (void)deleteFromTable:(NSString *)collectionName forCategory:(NSString *)category;

@end
