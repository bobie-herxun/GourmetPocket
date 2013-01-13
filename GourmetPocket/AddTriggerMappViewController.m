//
//  AddTriggerMappViewController.m
//  GourmetPocket
//
//  Created by Bobie on 1/11/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "AddTriggerMappViewController.h"
#import "LQTracker.h"
#import <CoreLocation/CoreLocation.h>

@interface AddTriggerMappViewController ()

@end

@implementation AddTriggerMappViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pinUp = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self zoomMapToLocation:[[[CLLocationManager alloc] init] location]];
    
    m_geonote = [[LQGeonote alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textFieldGeonote resignFirstResponder];
}

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    [textFieldGeonote becomeFirstResponder];
//}

#pragma mark - Methods
- (void)zoomMapToLocation:(CLLocation *)_location
{
    if (_location) {
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.05;
        span.longitudeDelta = 0.05;
        
        MKCoordinateRegion region;
        
        [m_mapView setCenterCoordinate:_location.coordinate animated:YES];
        
        region.center = _location.coordinate;
        region.span   = span;
        
        [m_mapView setRegion:region animated:YES];
    }
}

- (void)setGeonotePositionFromMapCenter
{
	MKCoordinateSpan currentSpan = m_mapView.region.span;
	// 111.0 km/degree of latitude * 1000 m/km * current delta * 20% of the half-screen width
	CGFloat desiredRadius = 111.0 * 1000 * currentSpan.latitudeDelta * 0.2;
    NSLog(@"Map center: %f, %f", m_mapView.centerCoordinate.latitude, m_mapView.centerCoordinate.longitude);
    m_geonote.location = [[CLLocation alloc] initWithLatitude:m_mapView.centerCoordinate.latitude
                                                       longitude:m_mapView.centerCoordinate.longitude];
	m_geonote.radius = desiredRadius < MINIMUM_GEONOTE_RADIUS ? MINIMUM_GEONOTE_RADIUS : desiredRadius;
    m_geonote.text = textFieldGeonote.text;
}

- (void)liftGeonotePin
{
    if (!pinUp) {
        self.geonoteTarget.hidden = NO;
        [UIView beginAnimations:@"" context:NULL];
        self.geonotePin.center = (CGPoint) {
            self.geonotePin.center.x,
            (self.geonotePin.center.y - PIN_Y_DELTA)
        };
        self.geonotePinShadow.center = (CGPoint) {
            (self.geonotePinShadow.center.x + PIN_SHADOW_X_DELTA),
            (self.geonotePinShadow.center.y - PIN_SHADOW_Y_DELTA)
        };
        [UIView setAnimationDuration:PIN_ANIMATION_DURATION];
        [UIView setAnimationDelay:UIViewAnimationCurveEaseOut];
        [UIView commitAnimations];
        pinUp = YES;
    }
}

- (void)dropGeonotePin
{
    if (pinUp) {
        self.geonoteTarget.hidden = YES;
        [UIView beginAnimations:@"" context:NULL];
        self.geonotePin.center = (CGPoint) {
            self.geonotePin.center.x,
            (self.geonotePin.center.y + PIN_Y_DELTA)
        };
        self.geonotePinShadow.center = (CGPoint) {
            (self.geonotePinShadow.center.x - PIN_SHADOW_X_DELTA),
            (self.geonotePinShadow.center.y + PIN_SHADOW_Y_DELTA)
        };
        [UIView setAnimationDuration:PIN_ANIMATION_DURATION];
        [UIView setAnimationDelay:UIViewAnimationCurveEaseIn];
        [UIView commitAnimations];
        
        pinUp = NO;
    }
}

#pragma mark - MKMapViewDelegate

- (void)m_mapView:(MKMapView *)m_mapView regionWillChangeAnimated:(BOOL)animated
{
    [self liftGeonotePin];
}

- (void)m_mapView:(MKMapView *)m_mapView regionDidChangeAnimated:(BOOL)animated
{
    [self dropGeonotePin];
}

#pragma mark - IBActions
- (IBAction)createNewGeonote:(id)sender {

    [self setGeonotePositionFromMapCenter];
    
    //[[MBProgressHUD showHUDAddedTo:self.view animated:YES] setLabelText:@"Saving"];
    [m_geonote save:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error description]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        } else if ([[responseDictionary objectForKey:@"result"] isEqualToString:@"ok"]) {
            //[self cancelGeonote];
            // if the geonote is close enough, we need the server to tell us about it to set up
            // a region to monitor there; do this with a location update.
            //[[LQTracker sharedTracker] enqueueCurrentLocationUpdate];
            //if (self.saveComplete) self.saveComplete();
            NSLog(@"Create Geonote successfully");
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [m_mapView release];
    [_geonotePin release];
    [_geonotePinShadow release];
    [_geonoteTarget release];
    [textFieldGeonote release];
    [super dealloc];
}
- (void)viewDidUnload {
    [m_mapView release];
    m_mapView = nil;
    [self setGeonotePin:nil];
    [self setGeonotePinShadow:nil];
    [self setGeonoteTarget:nil];
    [textFieldGeonote release];
    textFieldGeonote = nil;
    [super viewDidUnload];
}
@end
