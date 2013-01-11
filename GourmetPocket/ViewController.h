//
//  ViewController.h
//  GourmetPocket
//
//  Created by Bobie on 1/8/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LQActivityManager.h"

@interface ViewController : UIViewController{
    LQActivityManager* activityManager;
    UINavigationController* m_navigationController;
    
    IBOutlet UILabel *labelResult;
    IBOutlet UIButton *btnLogIn;
}

#pragma mark - IBActions
- (IBAction)mainPageQuery:(id)sender;
- (IBAction)userLogIn:(id)sender;
- (IBAction)addTrigger:(id)sender;

#pragma mark - methods
- (void)refresh;

@end
