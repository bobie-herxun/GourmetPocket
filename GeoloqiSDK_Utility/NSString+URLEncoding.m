//
//  NSString+URLEncoding.m
//  Geonotes
//
//  Created by Aaron Parecki on 7/8/12.
//  Copyright (c) 2012 Geoloqi, Inc. All rights reserved.
//

#import "NSString+URLEncoding.h"

@implementation NSString (URLEncoding)
-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return ( NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               ( CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding));
}
@end