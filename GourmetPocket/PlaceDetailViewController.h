//
//  PlaceDetailViewController.h
//  GourmetPocket
//
//  Created by BobieAir on 13/1/26.
//  Copyright (c) 2013年 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class PlaceTableViewController;

@interface PlaceDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate> {
    NSString* m_placeName;
    NSString* m_placeTelNumber;
    NSString* m_locationLatitude;
    NSString* m_locationLongitude;
}

@property (nonatomic, assign) PlaceTableViewController* parentPlaceTableViewController;
@property (retain, nonatomic) IBOutlet UITableView *tableViewDetails;
@property (retain, nonatomic) IBOutlet MKMapView *mapPlaceDetails;

// Methods
//
- (void)initPlaceDetails:(NSDictionary*)dictPlace;

// IBOutlets
//

// IBActions
//
- (IBAction)backToPlaceTable:(id)sender;

@end
