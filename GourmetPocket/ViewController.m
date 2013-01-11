//
//  ViewController.m
//  GourmetPocket
//
//  Created by Bobie on 1/8/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "ViewController.h"
#import "LQSession.h"
#import "LQTracker.h"
#import "AddTriggerMappViewController.h"

@interface ViewController ()

@end

@implementation ViewController

static NSString *const constUsernameEmail = @"bobie@herxun.co";
static NSString *const constPassword = @"ahchie77";

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.title = @"GourmetPocket";
    
    activityManager = [LQActivityManager sharedManager];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mainPageQuery:(id)sender {
    
    //[self refresh];
    [activityManager reloadActivityFromDB];
}

- (IBAction)userLogIn:(id)sender
{
    [LQSession requestSessionWithUsername:constUsernameEmail
                                 password:constPassword
                               completion:^(LQSession *session, NSError *error)
    {// callback code section
        if(session.accessToken)
        {
            NSLog(@"Logged in successfully! %@", session.accessToken);

            // Save the session so it will be restored next time
            [LQSession setSavedSession:session];

            // Register for push notifications which will show the prompt now
            //[self registerForPushNotifications];

            // Start tracking location in "adaptive" mode, which will show the location prompt
            //[[LQTracker sharedTracker] setProfile:LQTrackerProfileAdaptive];
            [[LQTracker sharedTracker] setProfile:LQTrackerProfileRealtime];
            
            // Post a notification so your UI can show the appropriate view
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GourmetPocket Push"
                                                                object:nil
                                                              userInfo:nil];
            
            labelResult.text = @"Logged in successfully";
            btnLogIn.enabled = NO;
        }
        else
        {
            // Failed login
            NSLog(@"Error logging in %@", error);
            // Display an alert about the error, probably you want to do something different
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error.userInfo objectForKey:@"error_description"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    }];
}

- (IBAction)addTrigger:(id)sender {
    
    AddTriggerMappViewController* addTriggerVC =
    [[AddTriggerMappViewController alloc] initWithNibName:@"AddTriggerMappViewController" bundle:nil];
    
    [self.navigationController pushViewController:addTriggerVC animated:YES];
}

- (void)refresh
{
    [activityManager reloadActivityFromAPI:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error)
    {// callback code section
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

- (void)dealloc {
    [labelResult release];
    [btnLogIn release];
    [super dealloc];
}
- (void)viewDidUnload {
    [labelResult release];
    labelResult = nil;
    [btnLogIn release];
    btnLogIn = nil;
    [super viewDidUnload];
}
@end
