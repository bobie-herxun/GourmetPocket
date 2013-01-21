//
//  MapPickerViewController.h
//  GourmetPocket
//
//  Created by BobieAir on 13/1/21.
//  Copyright (c) 2013年 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class NewPlaceViewController;

@interface MapPickerViewController : UIViewController <MKMapViewDelegate> {
    MKPointAnnotation *m_annotatePoint;
}

// Properties
//
@property (nonatomic, assign) NewPlaceViewController* parentNewPlaceViewController;


// IBOutlets
//
@property (retain, nonatomic) IBOutlet MKMapView *mapLocation;


// IBActions
//
- (IBAction)donePicking:(id)sender;
- (IBAction)locateMe:(id)sender;

@end
