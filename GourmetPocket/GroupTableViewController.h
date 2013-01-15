//
//  GroupTableViewController.h
//  GourmetPocket
//
//  Created by Bobie on 1/14/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LQLayerManager.h"

@class MainViewController;

@interface GroupTableViewController : UITableViewController{
    LQLayerManager* m_geoloqiLayerManager;
    NSMutableArray* jsonResult;
}

@property (nonatomic, assign) MainViewController* mainVC;

- (IBAction)groupBackToMain:(id)sender;

@end
