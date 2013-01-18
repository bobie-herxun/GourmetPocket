//
//  GroupTableViewController.h
//  GourmetPocket
//
//  Created by Bobie on 1/14/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQLayerManager.h"
#import "GeoloqiLayerManager.h"

// For pull-down-to-refresh mechanism
#import "PullRefreshTableViewController.h"

@class AppDelegate;
@class MainViewController;

//@interface GroupTableViewController : UITableViewController{
@interface GroupTableViewController : PullRefreshTableViewController{
    AppDelegate* gourmetPocketAppdelegate;
    GeoloqiLayerManager* m_geoloqiLayerManager;
    NSMutableArray* m_layers;
    NSMutableArray* jsonResult;
    
    IBOutlet UIView *viewLoadingIndicator;
    IBOutlet UIActivityIndicatorView *loadingActivityIndicator;
}

@property (nonatomic, assign) MainViewController* mainVC;
@property (nonatomic, assign) BOOL isLoaded;

- (void)backToGroup;
- (void)createNewGroupWithDictionary:(NSDictionary*)dictNewGroup;

- (IBAction)groupBackToMain:(id)sender;
- (IBAction)groupRefreshFromAPI:(id)sender;

- (void)fetchLayersFromDB;

@end
