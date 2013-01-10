//
//  SampleCode.m
//  GourmetPocket
//
//  Created by Bobie on 1/9/13.
//  Copyright (c) 2013 Bobie. All rights reserved.
//

#import "SampleCode.h"
#import "LQSession.h"

@implementation SampleCode


- (void)myRequestWithMethod
{
    // send a message to all the users in the group
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[NSNumber numberWithBool:true] forKey:@"push"];
    [params setObject:@"Hello everyone!" forKey:@"text"];

    NSMutableURLRequest *request = [[[LQSession savedSession] requestWithMethod:@"POST"
                                                                           path:@"/group/message/d6QwhleSy" payload:params] mutableCopy];
    
    [request setValue:[NSString stringWithFormat:@"OAuth %@", [LQSession savedSession].accessToken] forHTTPHeaderField:@"Authorization"];
    [[LQSession savedSession] runAPIRequest:request completion:^(NSHTTPURLResponse *response, NSDictionary *responseDictionary, NSError *error) {
        NSLog(@"Response to sending a message to the group: %@ error:%@", responseDictionary, error);
    }];
}

@end
