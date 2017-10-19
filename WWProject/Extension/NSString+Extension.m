//
//  NSString+Extension.m
//  WWProject
//
//  Created by zhai chunlin on 17/10/12.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

- (NSDictionary *)paramStringToDictionary
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    for (NSString *param in [self componentsSeparatedByString:@"&"]) {
        if ([param hasPrefix:@"signature"]) {
            NSRange range = [param rangeOfString:@"="];
            [params setValue:[param substringFromIndex:range.location+1] forKey:[param substringToIndex:range.location]];
            continue;
        }
        NSArray *kv = [param componentsSeparatedByString:@"="];
        [params setValue:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
    }
    
    return [params copy];
}

@end
