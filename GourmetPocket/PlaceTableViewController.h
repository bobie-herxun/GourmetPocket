//
//  PlaceTableViewController.h
//  GourmetPocket
//
//  Created by Bobie on 1/17/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeoloqiPlaceManager.h"

@class GroupTableViewController;

@interface PlaceTableViewController : UITableViewController {
    GeoloqiPlaceManager* m_geoloqiPlaceManager;
    NSMutableArray* m_places;
    
    BOOL m_bLoaded;
    IBOutlet UIView *viewActivityIndicator;
    IBOutlet UIActivityIndicatorView *activityIndicator;
}

- (void)cancelNewPlace;
- (void)createNewPlaceWithDictionary:(NSDictionary*)dictNewPlace;

@property (nonatomic, assign) GroupTableViewController* parentGroupTableView;
@property (nonatomic, assign) NSString* parentLayerId;

@end
