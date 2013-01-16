//
//  GroupTableViewController.m
//  GourmetPocket
//
//  Created by Bobie on 1/14/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "GroupTableViewController.h"
#import "MainViewController.h"

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
        m_geoloqiLayerManager = [[LQLayerManager alloc] init];
    }
    
//    dispatch_async(kBgQueue, ^{
//        [self performSelectorOnMainThread:@selector(fetchData)
//                               withObject:nil
//                            waitUntilDone:YES];
//    });
    
    // Initialize m_layers
    m_layers = [@[] mutableCopy];
    
    //[self addGeoloqiLayerWithName:@"New Layer 20130116" AndDescription:@"testing with core data support" AndOthers:nil];
    [self fetchLayersFromDB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    GeoloqiLayers* layer = [m_layers objectAtIndex:indexPath.section];
    
    cell.textLabel.text = layer.name;
    cell.detailTextLabel.text = layer.desc;
    
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

- (IBAction)groupBackToMain:(id)sender {
    [self.mainVC backToMain];
}

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
        NSLog(@"GourmetPocket, Group, Failed to add new layer into DB");
    }
    
}

- (void)fetchLayersFromDB
{
    for (NSMutableArray* currentSet in m_layers)
    {
        [currentSet removeAllObjects];
    }
    
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
        [m_layers insertObject:currentLayer atIndex:0];
    }
    
    [returnObjs release];
    
    [self.tableView reloadData];
}

@end
