//
//  LQGeonote.h
//  Geonotes
//
//  Created by Kenichi Nakamura on 7/30/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LQGeonoteDelegate.h"
#import <CoreLocation/CoreLocation.h>

@interface LQGeonote : NSObject {
    int maxTextLength;
}

@property (nonatomic, assign) CLLocation *location;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSString *text;
@property (nonatomic, assign) id <LQGeonoteDelegate> delegate;

- (id)initWithDelegate:(id<LQGeonoteDelegate>)delegate;

- (BOOL)isSaveable:(int)maxTextLength;
- (BOOL)isSaveable;
- (void)save:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))complete;

@end