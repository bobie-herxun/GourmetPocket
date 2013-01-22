//
//  MapPickerViewController.m
//  GourmetPocket
//
//  Created by BobieAir on 13/1/21.
//  Copyright (c) 2013年 Bobie. All rights reserved.
//

#import "MapPickerViewController.h"
#import "NewPlaceViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface MapPickerViewController ()

@end

@implementation MapPickerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        m_bUserLocationLoaded = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.mapLocation.delegate = self;
    
    // Add long-press gesture
    UILongPressGestureRecognizer* longPressMap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressMap.minimumPressDuration = 2.0f;
    [self.mapLocation addGestureRecognizer:longPressMap];
    [longPressMap release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Methods
- (void)handleLongPress:(UIGestureRecognizer*)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    [self.mapLocation removeAnnotation:m_annotatePoint];

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapLocation];
    CLLocationCoordinate2D touchMapCoordinate =
    [self.mapLocation convertPoint:touchPoint toCoordinateFromView:self.mapLocation];

    m_annotatePoint = [[MKPointAnnotation alloc] init];
    m_annotatePoint.coordinate = touchMapCoordinate;
    m_annotatePoint.title = @"Location";
    m_annotatePoint.subtitle = @"Place Description";

    [self.mapLocation addAnnotation:m_annotatePoint];
}

#pragma mark - MapView Delegates
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!m_bUserLocationLoaded)
        [self locateUserCenter:mapView];
}

- (void)locateUserCenter:(MKMapView*)mapView
{
    MKCoordinateRegion regionCenter = MKCoordinateRegionMake(mapView.userLocation.coordinate,
                                                             MKCoordinateSpanMake(0.005, 0.005));
    regionCenter = [mapView regionThatFits:regionCenter];
    [mapView setRegion:regionCenter animated:YES];
    
    m_bUserLocationLoaded = YES;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    static NSString *reuseId = @"pin";
    MKPinAnnotationView *pav = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (pav == nil)
    {
        pav = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId];
        pav.draggable = YES;
        pav.canShowCallout = YES;
    }
    else
    {
        pav.draggable = YES;
        pav.annotation = annotation;
    }
    
    return pav;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    m_annotatePoint.subtitle = @"Getting address...";
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    CLLocation* location = [[CLLocation alloc] initWithLatitude:view.annotation.coordinate.latitude
                                                      longitude:view.annotation.coordinate.longitude];
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error)
        {
            // Completion callback
            if (error)
            {
                NSLog(@"Fail to reverse-geocode the coordinate");
                return;
            }
            
            CLPlacemark* placeMark = [placemarks objectAtIndex:0];
            NSString* addressString = ABCreateStringWithAddressDictionary(placeMark.addressDictionary, NO);
            
            m_annotatePoint.subtitle = addressString;
        }];
}

#pragma mark - IBActions
- (IBAction)donePicking:(id)sender {
    [self.parentNewPlaceViewController donePickingLocation:m_annotatePoint.coordinate withGeocode:m_annotatePoint.subtitle];
}

- (IBAction)locateMe:(id)sender{
    [self locateUserCenter:self.mapLocation];
}

#pragma mark - Destructors
- (void)dealloc {
    [_mapLocation release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setMapLocation:nil];
    [super viewDidUnload];
}
@end
