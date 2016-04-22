//
//  NSString+Query.m
//  DictObjc
//
//  Created by Hank Bao on 16/4/22.
//  Copyright © 2016 zTap Studio. All rights reserved.
//

#import "NSString+Query.h"

@implementation NSString (Query)

- (NSURL *)zt_queryURL {
    NSString *encoded = [self stringByAddingPercentEncodingWithAllowedCharacters:
                         [NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *urlString = [NSString stringWithFormat:@"https://cn.bing.com/dict/search?q=%@", encoded];
    return [NSURL URLWithString:urlString];
}

@end
