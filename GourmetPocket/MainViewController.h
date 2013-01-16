//
//  MainViewController.h
//  GourmetPocket
//
//  Created by Bobie on 1/14/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *textLabelMain;

- (void)backToMain;

- (IBAction)mainLogIn:(id)sender;
- (IBAction)mainCreateNewUser:(id)sender;

@end
