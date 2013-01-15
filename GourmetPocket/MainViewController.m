//
//  MainViewController.m
//  GourmetPocket
//
//  Created by Bobie on 1/14/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "MainViewController.h"
#import "GroupTableViewController.h"

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
