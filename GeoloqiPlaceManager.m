//
//  GeoloqiPlaceManager.m
//  GourmetPocket
//
//  Created by BobieAir on 13/1/19.
//  Copyright (c) 2013年 Bobie. All rights reserved.
//

#import "GeoloqiPlaceManager.h"
#import "LQSession.h"

@implementation GeoloqiPlaceManager {
    NSMutableArray *m_places;
    BOOL m_isSorted;
}

static GeoloqiPlaceManager* m_placeManager;
static NSString *const kLQPlaceListPath = @"/place/list";
static NSString *const kLQPlaceNameDictionaryKey = @"name";
static NSString *const kLQPlaceNewPlacePath = @"/place/create";
static NSString *const kLQLayerIDKey = @"layer_id";

#pragma mark -

+ (void)initialize
{
    if (!m_placeManager)
        m_placeManager = [self new];
}

+ (GeoloqiPlaceManager*)sharedManager
{
    return m_placeManager;
}

#pragma mark -

- (GeoloqiPlaceManager*)init
{
    self = [super init];
    if (self) {
        m_isSorted = NO;
    }
    return self;
}

#pragma mark -

- (NSArray *)places
{
//    if (!m_isSorted) {
//        [m_places sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
//            NSString *title1 = [obj1 objectForKey:@"name"];
//            NSString *title2 = [obj2 objectForKey:@"name"];
//            return [title1 localizedCaseInsensitiveCompare:title2];
//        }];
//        m_isSorted = YES;
//    }
    return [NSArray arrayWithArray:m_places];
}

- (NSInteger)placeCount
{
    
    return m_places.count;
}

#pragma mark -

- (void)reloadPlacesFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion withLayerId:(NSString*)layer_id
{
    LQSession *session = [LQSession savedSession];
    
    NSDictionary* dictPayload = [NSDictionary dictionaryWithObject:layer_id forKey:@"layer_id"];
    
    NSURLRequest *request = [session requestWithMethod:@"GET"
                                                  path:kLQPlaceListPath
                                               payload:dictPayload];
    [session runAPIRequest:request
                completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
                    
                    if (error) {
                        NSLog(@"GeoloqiPlaceManager: fail to reload places");
                    } else {
                        
                        NSMutableArray *_places = [[NSMutableArray alloc] init];
                        
//                        for (NSString *key in responseDictionary) {
//                            for (NSDictionary *item in [responseDictionary objectForKey:key]) {
//                                [_places addObject:item];
//                            }
//                        }
                        for (NSDictionary* item in responseDictionary)
                        {
                            [_places addObject:item];
                        }
                        
                        m_places = _places;
                        m_isSorted = NO;
                    }
                    
                    if(completion) completion(response, responseDictionary, error);
                }];
}

- (void)createNewPlace:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion
        withDictionary:(NSDictionary*)dictNewLayer
{
    LQSession* session = [LQSession savedSession];
    
    NSURLRequest* request = [session requestWithMethod:@"POST"
                                                  path:kLQPlaceNewPlacePath
                                               payload:dictNewLayer];
    
    [session runAPIRequest:request
                completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
                    
                    if (error)
                    {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    }
                    else
                    {
                        // Let view-controller trigger the refresh
                    }
                    
                    if (completion)
                        completion(response, responseDictionary, error);
                }];
}

@end
