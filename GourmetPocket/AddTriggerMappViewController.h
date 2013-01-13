//
//  AddTriggerMappViewController.h
//  GourmetPocket
//
//  Created by Bobie on 1/11/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "LQGeonote.h"

#define MINIMUM_GEONOTE_RADIUS 150.0
#define PIN_Y_DELTA            30
#define PIN_SHADOW_X_DELTA     10
#define PIN_SHADOW_Y_DELTA     20
#define PIN_ANIMATION_DURATION 0.2

@interface AddTriggerMappViewController : UIViewController <UITextFieldDelegate>
{
    IBOutlet MKMapView *m_mapView;
    LQGeonote* m_geonote;
    BOOL pinUp;
    IBOutlet UITextField *textFieldGeonote;
}

//@property (nonatomic, strong) IBOutlet UIImageView *geonotePin;
//@property (nonatomic, strong) IBOutlet UIImageView *geonotePinShadow;
//@property (nonatomic, strong) IBOutlet UIImageView *geonoteTarget;
@property (retain, nonatomic) IBOutlet UIImageView *geonotePin;
@property (retain, nonatomic) IBOutlet UIImageView *geonotePinShadow;
@property (retain, nonatomic) IBOutlet UIImageView *geonoteTarget;

- (IBAction)createNewGeonote:(id)sender;
@end
