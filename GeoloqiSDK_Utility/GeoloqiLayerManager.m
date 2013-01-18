//
//  GeoloqiLayerManager.m
//  GourmetPocket
//
//  Created by Bobie on 1/17/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "GeoloqiLayerManager.h"
#import "LQSession.h"
#import "AppDelegate.h"

@implementation GeoloqiLayerManager{
    NSMutableArray *m_layers;
    BOOL m_isSorted;
}

static GeoloqiLayerManager* m_layerManager;
static NSString *const kLQLayerListPath = @"/layer/list"; //@"/layer/app_list";
static NSString *const kLQLayerSubscribePath = @"/layer/subscribe";
static NSString *const kLQLayerUnsubscribePath = @"/layer/unsubscribe";
static NSString *const kLQLayerNameDictionaryKey = @"name";
static NSString *const kLQLayerIDKey = @"layer_id";

#pragma mark -

+ (void)initialize
{
    if (!m_layerManager)
        m_layerManager = [self new];
}

+ (GeoloqiLayerManager*)sharedManager
{
    return m_layerManager;
}

#pragma mark -

- (GeoloqiLayerManager*)init
{
    self = [super init];
    if (self) {
        m_isSorted = NO;
    }
    return self;
}

#pragma mark -

- (NSArray *)layers
{
    if (!m_isSorted) {
        [m_layers sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSString *title1 = [obj1 objectForKey:@"name"];
            NSString *title2 = [obj2 objectForKey:@"name"];
            return [title1 localizedCaseInsensitiveCompare:title2];
        }];
        m_isSorted = YES;
    }
    return [NSArray arrayWithArray:m_layers];
}

- (NSInteger)layerCount
{
    
    return m_layers.count;
}

#pragma mark -

- (void)reloadLayersFromAPI:(void (^)(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error))completion
{
    LQSession *session = [LQSession savedSession];
    NSURLRequest *request = [session requestWithMethod:@"GET"
                                                  path:kLQLayerListPath
                                               payload:nil];
    [session runAPIRequest:request
                completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
                    
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                        [alert release];
                    } else {
                        
                        NSMutableArray *_layers = [[NSMutableArray alloc] init];
                        
                        for (NSString *key in responseDictionary) {
                            for (NSDictionary *item in [responseDictionary objectForKey:key]) {
                                [_layers addObject:item];
                            }
                        }
                        
                        m_layers = _layers;
                        m_isSorted = NO;
                    }
                    
                    if(completion) completion(response, responseDictionary, error);
                }];
}

#pragma mark -

- (void)manageSubscriptionForLayerAtIndex:(NSInteger)index subscribe:(BOOL)subscribe
{
    if (subscribe)
        [AppDelegate registerForPushNotificationsIfNotYetRegistered];
    
    LQSession *session = [LQSession savedSession];
    NSDictionary *layer = [m_layers objectAtIndex:index];
    NSString *path = [NSString stringWithFormat:@"%@/%@",
                      subscribe ? kLQLayerSubscribePath : kLQLayerUnsubscribePath,
                      [layer objectForKey:kLQLayerIDKey]];
    NSURLRequest *request = [session requestWithMethod:@"POST"
                                                  path:path
                                               payload:nil];
    [session runAPIRequest:request
                completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
                    if (error) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                        message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                        [alert show];
                    }
                }];
}

@end
