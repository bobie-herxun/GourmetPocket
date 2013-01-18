//
//  MainViewController.m
//  GourmetPocket
//
//  Created by Bobie on 1/14/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "MainViewController.h"
#import "GroupTableViewController.h"
#import "LQSession.h"
#import "LQTracker.h"

static NSString *const constUsernameEmail = @"ahchic@hotmail.com"; //@"bobie@herxun.co";
static NSString *const constPassword = @"ahchie77";
static NSString *const constNewUsernameEmail = @"ahchic@hotmail.com";

@interface MainViewController ()

@end

@implementation MainViewController

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
    //[self showLoadingIndicator];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - for "Loading" HUD
- (void)showLoadingIndicator
{
    if (!activityIndicator)
    {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    [activityIndicator startAnimating];
    activityIndicator.hidesWhenStopped = YES;
    [self performSelector:@selector(afterLoading) withObject:nil afterDelay:4.0f];
}

- (void)afterLoading
{
    [activityIndicator stopAnimating];
}
//*/

#pragma mark - methods of MainViewController

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueIdGroups"]) {
        //GroupTableViewController* groupTableViewController = (GroupTableViewController*)[segue.destinationViewController rootViewController];
        //GroupTableViewController* groupTableViewController = (GroupTableViewController*)(segue.destinationViewController);
        UINavigationController* navViewController = segue.destinationViewController;
        GroupTableViewController* groupTableViewController = [[navViewController viewControllers] lastObject];
        groupTableViewController.mainVC = self;
    }
}

- (void)backToMain
{
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{;}];
}

- (IBAction)mainLogIn:(id)sender {
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
             [[LQTracker sharedTracker] setProfile:LQTrackerProfileAdaptive];
             
             // Post a notification so your UI can show the appropriate view
             [[NSNotificationCenter defaultCenter] postNotificationName:@"GourmetPocket Push"
                                                                 object:nil
                                                               userInfo:nil];
             
             _textLabelMain.text = @"Logged in successfully";
             
             [self registerPushAfterSuccessfulLogIn];
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

- (IBAction)mainCreateNewUser:(id)sender {
    
    NSLog(@"Should do nothing");
    /*
    [LQSession createAccountWithUsername:constNewUsernameEmail
                                password:constPassword
                                   extra:nil
                              completion:^(LQSession *session, NSError *error)
        {
            if(session.accessToken)
            {
                NSLog(@"Logged in successfully! %@", session.accessToken);

                // Save the session so it will be restored next time
                [LQSession setSavedSession:session];
                                      
                // Register for push notifications which will show the prompt now
                //[self registerForPushNotifications];
                                      
                // Start tracking location in "adaptive" mode, which will show the location prompt
                [[LQTracker sharedTracker] setProfile:LQTrackerProfileAdaptive];
                                      
                // Post a notification so your UI can show the appropriate view
                [[NSNotificationCenter defaultCenter] postNotificationName:@"GourmetPocket"
                                                                    object:nil
                                                                  userInfo:nil];
            }
            else
            {
                // Failed login
                NSLog(@"Error logging in %@", error);
                [[[UIAlertView alloc] initWithTitle:@"Error"
                                            message:[error.userInfo
                                                     objectForKey:@"error_description"] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
            }
        }];
     */
}

- (void)registerPushAfterSuccessfulLogIn
{
    _textLabelMain.text = @"Register Push Notification";
    [LQSession registerForPushNotificationsWithCallback:^(NSData *deviceToken, NSError *error) {
        if(error){
            _textLabelMain.text = @"Failed Reg Push";
            NSLog(@"Failed to register for push tokens: %@", error);
        } else {
            _textLabelMain.text = @"Push Notification Reg";
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(authenticationDidSucceed:)
                                                         name:LQTrackerLocationChangedNotification
                                                       object:nil];
            NSLog(@"Got a push token! %@", deviceToken);
        }
    }];
}

- (void)dealloc {
    [_textLabelMain release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextLabelMain:nil];
    [super viewDidUnload];
}
@end
