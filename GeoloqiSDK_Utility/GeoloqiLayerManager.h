//
//  GeoloqiLayerManager.h
//  GourmetPocket
//
//  Created by Bobie on 1/17/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeoloqiLayerManager : NSObject


// returns the singleton layer manager instance
//
+ (GeoloqiLayerManager*)sharedManager;

// returns a *sorted* immutable copy of the layers list
//
- (NSArray *)layers;

// returns count of layers in the layers list
//
- (NSInteger)layerCount;

// reloads the layer list from the API
//
- (void)reloadLayersFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion;

// creates a new layer
//
- (void)createNewLayer:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion
        withDictionary:(NSDictionary*)dictNewLayer;

// subscribes or unsubscribes from the layer at the given index
//
- (void)manageSubscriptionForLayerAtIndex:(NSInteger)index subscribe:(BOOL)subscribe;

@end
