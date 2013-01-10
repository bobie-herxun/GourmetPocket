//
//  ViewController.m
//  GourmetPocket
//
//  Created by Bobie on 1/8/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    activityManager = [LQActivityManager sharedManager];
    
    [self refresh];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mainPageQuery:(id)sender {
    
    
}

- (void)refresh
{
    [activityManager reloadActivityFromAPI:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        
        if (error)
        {
            
        }
        else
        {
            
        }
        
        NSLog(@"activity refresh");
        
        // Tell the table to reload
        //[self.tableView reloadData];
        //[self addOrRemoveOverlay];
        
        // Call this to indicate that we have finished "refreshing".
        // This will then result in the headerView being unpinned (-unpinHeaderView will be called).
        //[self refreshCompleted];
        
        // apparently need to recall loadMoreCompleted to reset the loadMore state
        //[self loadMoreCompleted];
        
    }];
}

@end
