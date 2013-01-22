//
//  PlaceTableViewController.m
//  GourmetPocket
//
//  Created by Bobie on 1/17/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "PlaceTableViewController.h"
#import "NewPlaceViewController.h"
#import "GeoloqiPlaceManager.h"

@interface PlaceTableViewController ()

@end

@implementation PlaceTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        m_bLoaded = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    if (!m_geoloqiPlaceManager)
    {
        [GeoloqiPlaceManager initialize];
        m_geoloqiPlaceManager = [GeoloqiPlaceManager sharedManager];
        
        if (!m_geoloqiPlaceManager)
        {
            NSLog(@"GourmetPocket Debug: PlaceTableViewController viewDidLoad failed to init m_geoloqiPlaceManager");
        }
    }
    
    // Initialize m_layers
    m_places = [@[] mutableCopy];
    
    [self performSelector:@selector(reloadPlacesFromGeoloqiAPI) withObject:nil afterDelay:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueIdNewPlace"])
    {
        NewPlaceViewController* newPlaceViewController = segue.destinationViewController;
        newPlaceViewController.parentPlaceTableViewController = self;
    }
}

- (void)cancelNewPlace
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)createNewPlaceWithDictionary:(NSDictionary*)dictNewPlace
{
    [self dismissModalViewControllerAnimated:YES];
    
    NSLog(@"PlaceTableViewController createNewPlaceWithDictionary");
    NSLog(@"name: %@", [dictNewPlace valueForKey:@"name"]);
    NSLog(@"description: %@", [dictNewPlace valueForKey:@"description"]);
    NSLog(@"geocode: %@", [dictNewPlace valueForKey:@"geocode"]);
    NSLog(@"Latitude: %@, Longitude: %@", [dictNewPlace valueForKey:@"latitude"],
                                          [dictNewPlace valueForKey:@"longitude"]);
    NSLog(@"daily trigger time: %@", [dictNewPlace valueForKey:@"dailyTriggerTime"]);
    
    NSMutableDictionary* mutableDictNewPlace = [dictNewPlace mutableCopy];
    [mutableDictNewPlace setObject:[NSString stringWithFormat:@"%@", self.parentLayerId] forKey:@"layer_id"];
    [mutableDictNewPlace setObject:@"1000" forKey:@"radius"];
    [mutableDictNewPlace setObject:@"11:00:00" forKey:@"time_from"];
    [mutableDictNewPlace setObject:@"13:00:00" forKey:@"time_to"];

    if (!m_geoloqiPlaceManager)
    {
        NSLog(@"GourmetPocket debug: createNewPlaceWithDictionary invalid GeoloqiPlaceManager");
        return;
    }
    
    //m_bLoaded = NO;
    //[self showLoadingIndicator];
    
    [m_geoloqiPlaceManager createNewPlace:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error){
        // Callback code chunk
        
        // Geoloqi return data will be stored inside GeoloqiPlaceManager and can be retrieved later
        // Only have to handle error here
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            [self reloadPlacesFromGeoloqiAPI];
        }
        
    }withDictionary:mutableDictNewPlace];
}

#pragma mark - for "Loading" HUD
- (void)showLoadingIndicator
{
    if (!activityIndicator)
    {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    viewActivityIndicator.hidden = NO;
    [activityIndicator startAnimating];
    activityIndicator.hidesWhenStopped = YES;
}

- (void)afterLoading
{
    m_bLoaded = YES;
    [activityIndicator stopAnimating];
    viewActivityIndicator.hidden = YES;
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
    if ([m_places count] > 0)
        return [m_places count];
    else if (!m_bLoaded)
        return 0;
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([m_places count] > 0)
    {
        static NSString *CellIdentifier = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        // Configure the cell...
        NSDictionary* dictPlace = [m_places objectAtIndex:indexPath.row];
        
        cell.textLabel.text = [dictPlace objectForKey:@"name"];
        cell.detailTextLabel.text = [dictPlace objectForKey:@"geocode"];
    }
    else if (![m_places count])
    {
        static NSString *CellIdentifier = @"cellIdCreateNewPlace";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!m_bLoaded)
            cell.hidden = YES;
    }
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - Methods

- (void)reloadPlacesFromGeoloqiAPI
{
    if (!m_geoloqiPlaceManager)
    {
        NSLog(@"GourmetPocket debug: reloadPlacesFromGeoloqiAPI invalid GeoloqiPlaceManager");
        return;
    }
    
    m_bLoaded = NO;
    [self showLoadingIndicator];
    
    NSString* layer_id = _parentLayerId;
    
    [m_geoloqiPlaceManager reloadPlacesFromAPI:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error){
        // Callback code chunk
        
        // Geoloqi return data will be stored inside GeoloqiPlaceManager and can be retrieved later
        // Only have to handle error here
        if (error)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            NSMutableArray* returnData = [[m_geoloqiPlaceManager places] mutableCopy];
            [self refreshPlaces:returnData];
            [self afterLoading];
            [self.tableView reloadData];
        }
    }withLayerId:layer_id];
}

- (void)refreshPlaces:(NSMutableArray*)places
{
    if (![places count])
    {
        return;
    }
    
    for (NSDictionary *item in places)
    {
        m_places = places;
    }
}

- (void)dealloc {
    [activityIndicator release];
    [viewActivityIndicator release];
    [super dealloc];
}
- (void)viewDidUnload {
    [activityIndicator release];
    activityIndicator = nil;
    [viewActivityIndicator release];
    viewActivityIndicator = nil;
    [super viewDidUnload];
}
@end
