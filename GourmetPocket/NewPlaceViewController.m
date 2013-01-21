//
//  NewPlaceViewController.m
//  GourmetPocket
//
//  Created by Bobie on 1/21/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "NewPlaceViewController.h"
#import "PlaceTableViewController.h"
#import "MapPickerViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface NewPlaceViewController ()

@end

@implementation NewPlaceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.scrollNewPlace setScrollEnabled:YES];
    [self.scrollNewPlace setContentSize:CGSizeMake(320, 1080)];
    
    self.textName.delegate = self;
    self.textAddress.delegate = self;
    self.textDescription.delegate = self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueIdMapPick"])
    {
        MapPickerViewController* mapPickerViewController = segue.destinationViewController;
        mapPickerViewController.parentNewPlaceViewController = self;
    }
}

- (void)donePickingLocation:(CLLocationCoordinate2D)coordinate
{
    [self dismissModalViewControllerAnimated:YES];
    
    NSLog(@"New place location picked");
    NSLog(@"latitude: %f", coordinate.latitude);
    NSLog(@"longitude: %f", coordinate.longitude);
    
    self.textLatLong.text = [NSString stringWithFormat:@"Lat:%3.4f, Long:%3.4f", coordinate.latitude, coordinate.longitude];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_scrollNewPlace release];
    [_textName release];
    [_textAddress release];
    [_textDescription release];
    [_textLatLong release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScrollNewPlace:nil];
    [self setTextName:nil];
    [self setTextAddress:nil];
    [self setTextDescription:nil];
    [self setTextLatLong:nil];
    [super viewDidUnload];
}
- (IBAction)createNewPlace:(id)sender {
    // Check if values are all valid
    //
    
    // Create a dictionary and pass to parent view-controller to create a new place
    //
    //CLLocation;
    
    NSArray* arrayPlaceValue = @[ _textName.text, _textAddress, _textDescription ];
    NSArray* arrayPlaceKey = @[ @"name", @"geocode", @"description" ];
    NSDictionary* dictNewPlace = [NSDictionary dictionaryWithObjects:arrayPlaceValue forKeys:arrayPlaceKey];
    
    [self.parentPlaceTableViewController createNewPlaceWithDictionary:dictNewPlace];
}

- (IBAction)cancelNewPlace:(id)sender {
    if (_parentPlaceTableViewController)
    {
        [_parentPlaceTableViewController cancelNewPlace];
    }
    else
    {
        NSLog(@"No parent view-controller to dismiss new-place view-controller");
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - Long-press on map-view
//handleLongPress
//- (void)handleLongPress:(UIGestureRecognizer*)gestureRecognizer
//{
//    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
//        return;
//    
//    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapLocation];
//    CLLocationCoordinate2D touchMapCoordinate =
//    [self.mapLocation convertPoint:touchPoint toCoordinateFromView:self.mapLocation];
//    
//    MKPointAnnotation *annotatePoint = [[MKPointAnnotation alloc] init];
//    annotatePoint.coordinate = touchMapCoordinate;
//    
//    [self.mapLocation addAnnotation:annotatePoint];
//
//    [annotatePoint release];
//}

#pragma mark - MapView Delegates
//- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    MKCoordinateRegion regionCenter = MKCoordinateRegionMake(mapView.userLocation.coordinate,
//                                                             MKCoordinateSpanMake(0.005, 0.005));
//    regionCenter = [mapView regionThatFits:regionCenter];
//    [mapView setRegion:regionCenter animated:YES];
//}
//
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
//    
//    static NSString *identifier = @"MyLocation";
//    if ([annotation isKindOfClass:[MKPointAnnotation class]]) {
//        
//        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapLocation dequeueReusableAnnotationViewWithIdentifier:identifier];
//        if (annotationView == nil) {
//            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
//        } else {
//            annotationView.annotation = annotation;
//        }
//        
//        annotationView.enabled = YES;
//        annotationView.canShowCallout = YES;
//        annotationView.draggable = YES;
//        
//        return annotationView;
//    }
//    
//    return nil; 
//}
//
//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState
//{
//    if (newState == MKAnnotationViewDragStateEnding)
//    {
//        CLLocationCoordinate2D droppedAt = annotationView.annotation.coordinate;
//        NSLog(@"dropped at %f,%f", droppedAt.latitude, droppedAt.longitude);
//        
//        //update the annotation
//        //see if its an information annotation
//        //        if ([annotationView.annotation isKindOfClass:[InfoAnnotation class]]) {
//        //            NSLog(@"Info annotation updating..");
//        //            InfoAnnotation* userAnnotation = ((InfoAnnotation *)annotationView.annotation);
//        //            [userAnnotation updateLocationWithServerForConvoy: self.title];
//        //        }
//        
//    }
//    
//    NSLog(@"123");
//    NSLog(@"123");
//}
//
//- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
//{
//    NSLog(@"123");
//}

#pragma mark - TextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
