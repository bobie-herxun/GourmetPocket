//
//  NewGroupViewController.m
//  GourmetPocket
//
//  Created by Bobie on 1/18/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "NewGroupViewController.h"
#import "GroupTableViewController.h"

@interface NewGroupViewController ()

@end

@implementation NewGroupViewController

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

- (IBAction)cancelNewGroup:(id)sender {
    [self.parentGroupTableView backToGroup];
}

- (IBAction)createNewGroup:(id)sender {
    
    if ([_textGroupName.text isEqualToString:@""] ||
        [_textGroupDescription.text isEqualToString:@""])
    {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Please enter valid name and description"
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"Ok", nil] show];
    }
    else
    {
        // Make a NSDictionary with name and description
        // Send back to GroupTableViewController to create new layer(group)
        NSDictionary* dictNewGroup =
        [NSDictionary dictionaryWithObjects:@[ _textGroupName.text, _textGroupDescription.text ]
                                    forKeys:@[ @"name", @"description" ]];
        
        NSLog(@"New group, name: %@ desc: %@",
              [dictNewGroup objectForKey:@"name"],
              [dictNewGroup objectForKey:@"description"]);
        
        [self.parentGroupTableView createNewGroupWithDictionary:dictNewGroup];
    }
}



- (void)dealloc {
    [_textGroupName release];
    [_textGroupDescription release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTextGroupName:nil];
    [self setTextGroupDescription:nil];
    [super viewDidUnload];
}
@end
