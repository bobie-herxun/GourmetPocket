//
//  GeoloqiPlaceManager.h
//  GourmetPocket
//
//  Created by BobieAir on 13/1/19.
//  Copyright (c) 2013年 Bobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoloqiPlaceManager : NSObject


// returns the singleton place manager instance
//
+ (GeoloqiPlaceManager*)sharedManager;

// returns a *sorted* immutable copy of the place list
//
- (NSArray *)places;

// returns count of layers in the layers list
//
- (NSInteger)placeCount;

// reloads the place list from the API
//
- (void)reloadPlacesFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion
                withLayerId:(NSString*)layer_id;

// API for view-controller: creates a new place
//
- (void)createNewPlace:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion withDictionary:(NSDictionary*)dictNewPlace;

@end
