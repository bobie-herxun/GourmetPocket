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
}

- (IBAction)mainPageQuery:(id)sender;

- (void)refresh;

@end
