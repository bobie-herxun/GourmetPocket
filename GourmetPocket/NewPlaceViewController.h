//
//  NewPlaceViewController.h
//  GourmetPocket
//
//  Created by Bobie on 1/21/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class PlaceTableViewController;

@interface NewPlaceViewController : UIViewController <MKMapViewDelegate, UITextFieldDelegate>

// Class properties
@property (nonatomic, assign) PlaceTableViewController* parentPlaceTableViewController;

// IBOutlets
//
@property (retain, nonatomic) IBOutlet UIScrollView *scrollNewPlace;
@property (retain, nonatomic) IBOutlet UITextField *textName;
@property (retain, nonatomic) IBOutlet UITextField *textAddress;
@property (retain, nonatomic) IBOutlet UITextField *textDescription;
@property (retain, nonatomic) IBOutlet MKMapView *mapLocation;
@property (retain, nonatomic) IBOutlet UILabel *textLatLong;
@property (retain, nonatomic) IBOutlet UIDatePicker *pickerDailyTime;

// IBActions
//
- (IBAction)createNewPlace:(id)sender;
- (IBAction)cancelNewPlace:(id)sender;

// Methods
//

@end
