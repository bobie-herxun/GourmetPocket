//
//  NewGroupViewController.h
//  GourmetPocket
//
//  Created by Bobie on 1/18/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GroupTableViewController;

@interface NewGroupViewController : UIViewController

- (IBAction)cancelNewGroup:(id)sender;
- (IBAction)createNewGroup:(id)sender;

@property (retain, nonatomic) IBOutlet UITextField *textGroupName;
@property (retain, nonatomic) IBOutlet UITextField *textGroupDescription;

@property (nonatomic, assign) GroupTableViewController* parentGroupTableView;

@end
