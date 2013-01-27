//
//  PlaceDetailViewController.m
//  GourmetPocket
//
//  Created by BobieAir on 13/1/26.
//  Copyright (c) 2013年 Bobie. All rights reserved.
//

#import "PlaceDetailViewController.h"
#import "PlaceTableViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface PlaceDetailViewController ()

@end

@implementation PlaceDetailViewController

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
    
    self.tableViewDetails.delegate = self;
    self.mapPlaceDetails.delegate = self;
 
    [self performSelector:@selector(locateUserCenter) withObject:nil afterDelay:1.0f];
    //[self locateUserCenter];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backToPlaceTable:(id)sender {
    [self.parentPlaceTableViewController backToPlaceTable];
}

#pragma mark - Methods
- (void)initPlaceDetails:(NSDictionary*)dictPlace
{
    m_placeName = [dictPlace objectForKey:@"name"];
    m_placeTelNumber = @"(02)2766-2000";
    m_locationLatitude = [dictPlace objectForKey:@"latitude"];
    m_locationLongitude = [dictPlace objectForKey:@"longitude"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    static NSString *CellIdentifier = @"cellIdPlaceDetail";
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (indexPath.row == 0)
    {
        cell.textLabel.text = m_placeName;
    }
    else
    {
        cell.textLabel.text = m_placeTelNumber;
    }
    
    return cell;
}

#pragma mark - Map delegate and methods
- (void)locateUserCenter
{
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake([m_locationLatitude floatValue] , [m_locationLongitude floatValue]);
    MKCoordinateRegion regionCenter = MKCoordinateRegionMake(location, MKCoordinateSpanMake(0.005, 0.005));
    regionCenter = [self.mapPlaceDetails regionThatFits:regionCenter];
    [self.mapPlaceDetails setRegion:regionCenter animated:YES];
    
    [self performSelector:@selector(addPlaceDetailAnnotation) withObject:nil afterDelay:0.5f];
}

- (void)addPlaceDetailAnnotation
{
    MKPointAnnotation* annotatePoint = [[MKPointAnnotation alloc] init];
    annotatePoint.coordinate = CLLocationCoordinate2DMake([m_locationLatitude floatValue], [m_locationLongitude floatValue]);
    annotatePoint.title = @"Location";
    annotatePoint.subtitle = @"Place Description";
    
    [self.mapPlaceDetails addAnnotation:annotatePoint];
    [self.mapPlaceDetails selectAnnotation:annotatePoint animated:YES];
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
    
    pav.animatesDrop = YES;
    pav.selected = YES;
    return pav;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    MKPointAnnotation* myAnnotation = [[self.mapPlaceDetails annotations] objectAtIndex:0];
    if (!myAnnotation)
    {
        NSLog(@"Cannot find annotation");
    }
    
    myAnnotation.subtitle = @"Getting address...";
    
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
         
         myAnnotation.subtitle = addressString;
         [addressString release];
     }];
    
    [geocoder release];
    [location release];
}

#pragma mark -

- (void)dealloc {
    [_tableViewDetails release];
    [_mapPlaceDetails release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableViewDetails:nil];
    [self setMapPlaceDetails:nil];
    [super viewDidUnload];
}
@end
