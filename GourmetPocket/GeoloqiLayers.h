//
//  GeoloqiLayers.h
//  GourmetPocket
//
//  Created by Bobie on 1/17/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GeoloqiLayers : NSManagedObject

@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * extra;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * public;
@property (nonatomic, retain) NSNumber * radius;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * layer_id;
@property (nonatomic, retain) NSNumber * subscribed;

@end
