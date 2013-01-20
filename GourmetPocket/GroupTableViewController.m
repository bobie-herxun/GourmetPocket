//
//  GroupTableViewController.m
//  GourmetPocket
//
//  Created by Bobie on 1/14/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "GroupTableViewController.h"
#import "MainViewController.h"
#import "NewGroupViewController.h"
#import "PlaceTableViewController.h"
#import "GeoloqiLayerManager.h"

// For core-data managed-object control, need AppDelegate
#import "AppDelegate.h"
// More, need to import ManagedObject entities
#import "GeoloqiLayers.h"

#define kBgQueue    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

@interface GroupTableViewController ()

@end

@implementation GroupTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _isLoaded = NO;
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
    
    gourmetPocketAppdelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (!m_geoloqiLayerManager)
    {
        [GeoloqiLayerManager initialize];
        m_geoloqiLayerManager = [GeoloqiLayerManager sharedManager];
        
        if (!m_geoloqiLayerManager)
        {
            NSLog(@"GourmetPocket Debug: GroupTableViewController viewDidLoad failed to init m_geoloqiLayerManager");
        }
    }
    
    // Initialize m_layers
    m_layers = [@[] mutableCopy];
    
    if (!_isLoaded)
    {
        [self showLoadingIndicator];
        [self performSelector:@selector(fetchLayersFromDB) withObject:nil afterDelay:1.0f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueIdNewGroup"]) {
        NewGroupViewController* newGroupViewController = segue.destinationViewController;
        newGroupViewController.parentGroupTableView = self;
    }
    else if ([segue.identifier isEqualToString:@"segueIdGroupsToPlaces"])
    {
        PlaceTableViewController* placeTableViewController = segue.destinationViewController;
        placeTableViewController.parentGroupTableView = self;
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        GeoloqiLayers* currentLayer = [m_layers objectAtIndex:indexPath.row];
        placeTableViewController.parentLayerId = currentLayer.layer_id;
        NSLog(@"Select layer id: %@", placeTableViewController.parentLayerId);
    }
}

- (void)backToGroup
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)createNewGroupWithDictionary:(NSDictionary*)dictNewGroup;
{
    NSLog(@"GroupTableViewController createNewGroupWithDictionary");
    NSLog(@"name: %@, desc: %@", [dictNewGroup objectForKey:@"name"],
                                [dictNewGroup objectForKey:@"description"]);
    
    if (!m_geoloqiLayerManager)
    {
        NSLog(@"GourmetPocket debug: reloadLayersFromGeoloqiAPI invalid GeoloqiLayerManager");
        return;
    }
    
    [m_geoloqiLayerManager createNewLayer:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {

        // Callback code chunk
        
        // Geoloqi return data will be stored inside GeoloqiLayerManager and can be retrieved later
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
            [self reloadLayersFromGeoloqiAPI];
            [self dismissModalViewControllerAnimated:YES];
        }
    } withDictionary:dictNewGroup];
}

#pragma mark - for "Loading" HUD
- (void)showLoadingIndicator
{
    if (!loadingActivityIndicator)
    {
        loadingActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    [loadingActivityIndicator startAnimating];
    loadingActivityIndicator.hidesWhenStopped = YES;
}

- (void)afterLoading
{
    [loadingActivityIndicator stopAnimating];
    [viewLoadingIndicator removeFromSuperview];
    
    _isLoaded = YES;
}

#pragma mark - LQLayerManager Utilizations
- (void)fetchData
{
    //NSLog(@"20130115 checkpoint, fetchData() called by thread");
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
    return [m_layers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellGroups";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    // Note: [UITableView dequeueReusableCellWithIdentifier:forIndexPath:] is for iOS 6.0 and later
    //       will cause previous OS versions crash
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if ([m_layers count] > 0)
    {
        GeoloqiLayers* layer = [m_layers objectAtIndex:indexPath.row];
        
        cell.textLabel.text = layer.name;
        cell.detailTextLabel.text = layer.desc;
        
        id path = layer.icon;
        NSURL *url = [NSURL URLWithString:path];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        cell.imageView.image = img;
    }
    else
    {
        //cell.textLabel.text = @"Loading...";
        //[cell.accessoryView setHidden:YES];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [m_layers count]-1)
        [self afterLoading];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
//*/

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

#pragma mark - PullRefreshTableViewController
- (void)refresh
{
    [self performSelector:@selector(reloadLayersFromGeoloqiAPI) withObject:nil afterDelay:2.0];
}

#pragma mark - Methods

- (IBAction)groupBackToMain:(id)sender {
    [self.mainVC backToMain];
}

- (IBAction)groupRefreshFromAPI:(id)sender {
    [self reloadLayersFromGeoloqiAPI];
}

- (void)reloadLayersFromGeoloqiAPI
{
    if (!m_geoloqiLayerManager)
    {
        NSLog(@"GourmetPocket debug: reloadLayersFromGeoloqiAPI invalid GeoloqiLayerManager");
        return;
    }
    
    [m_geoloqiLayerManager reloadLayersFromAPI:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        // Callback code chunk
        
        // Geoloqi return data will be stored inside GeoloqiLayerManager and can be retrieved later
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
            NSMutableArray* returnData = [[m_geoloqiLayerManager layers] mutableCopy];
            if (![returnData count])
            {
                return;
            }
            else
            {
                [self clearDBLayers];
                [self refreshDBLayers:returnData];
                [self fetchLayersFromDB];
            }
        }
    }];
    
    [self stopLoading];
}

- (void)clearDBLayers
{
    NSFetchRequest* requestFetch = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"GeoloqiLayers"
                                              inManagedObjectContext:[gourmetPocketAppdelegate managedObjectContext]];
    [requestFetch setEntity:entity];
    NSError* error = nil;
    NSMutableArray* returnObjs = [[[gourmetPocketAppdelegate managedObjectContext] executeFetchRequest:requestFetch error:&error] mutableCopy];
    
    [requestFetch release];
    
    // delete all object in entity "GeoloqiLayers"
    for (GeoloqiLayers* currentLayer in returnObjs)
    {
        [[gourmetPocketAppdelegate managedObjectContext] deleteObject:currentLayer];
    }
    
    [returnObjs release];
    
    if (![gourmetPocketAppdelegate.managedObjectContext save:&error]) {
        NSLog(@"GourmetPocket, Group, Failed to clear GeoloqiLayers in CoreData");
    }
}

// This is a develop-testing function
- (void)addGeoloqiLayerWithName:(NSString*)name AndDescription:(NSString*)description AndOthers:(NSMutableArray*)otherInfo
{
    GeoloqiLayers* geoloqiLayer =
    (GeoloqiLayers*) [NSEntityDescription insertNewObjectForEntityForName:@"GeoloqiLayers"
                                                   inManagedObjectContext:[gourmetPocketAppdelegate managedObjectContext]];
    
    geoloqiLayer.name = name;
    geoloqiLayer.desc = description;
    
    // Retrieve additional information from NSMutableArray
    // ...
    
    NSError* error = nil;
    if (![gourmetPocketAppdelegate.managedObjectContext save:&error]) {
        NSLog(@"GourmetPocket Debug, GroupTableViewController addGeoloqiLayerWithName, Failed to add new layer into DB");
    }
    
}

// Refresh layers in DB with GeoloqiAPI return data (if any)
- (void)refreshDBLayers:(NSMutableArray*)layers
{
    if (![layers count])
    {
        return;
    }

    for (NSDictionary *item in layers)
    {
        GeoloqiLayers* geoloqiLayer =
        (GeoloqiLayers*) [NSEntityDescription insertNewObjectForEntityForName:@"GeoloqiLayers"
                                                       inManagedObjectContext:[gourmetPocketAppdelegate managedObjectContext]];

        geoloqiLayer.layer_id = [item objectForKey:@"layer_id"];
        geoloqiLayer.name = [item objectForKey:@"name"];
        geoloqiLayer.desc = [item objectForKey:@"description"];
        geoloqiLayer.icon = [item objectForKey:@"icon"];
        geoloqiLayer.url = [item objectForKey:@"url"];
        geoloqiLayer.subscribed = [item objectForKey:@"subscribed"];
        
        NSError* error = nil;
        if (![gourmetPocketAppdelegate.managedObjectContext save:&error]) {
            NSLog(@"GourmetPocket Debug, GroupTableViewController refreshDBLayers, Failed to add new layer into DB");
            break;
        }
    }
}

- (void)fetchLayersFromDB
{
    [m_layers removeAllObjects];
    
    NSFetchRequest* requestFetch = [[NSFetchRequest alloc] init];
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"GeoloqiLayers"
                                              inManagedObjectContext:[gourmetPocketAppdelegate managedObjectContext]];
    [requestFetch setEntity:entity];
    NSError* error = nil;
    NSMutableArray* returnObjs = [[[gourmetPocketAppdelegate managedObjectContext] executeFetchRequest:requestFetch error:&error] mutableCopy];
    
    [requestFetch release];
    
    // update table view
    for (GeoloqiLayers* currentLayer in returnObjs)
    {
        NSLog(@"fetchLayersFromDB, name: %@ desc: %@", currentLayer.name, currentLayer.desc);
        [m_layers insertObject:currentLayer atIndex:0];
    }
    
    [returnObjs release];
    
    [self.tableView reloadData];
}

- (void)dealloc {
    [loadingActivityIndicator release];
    [viewLoadingIndicator release];
    [super dealloc];
}
- (void)viewDidUnload {
    [loadingActivityIndicator release];
    loadingActivityIndicator = nil;
    [viewLoadingIndicator release];
    viewLoadingIndicator = nil;
    [super viewDidUnload];
}
@end
