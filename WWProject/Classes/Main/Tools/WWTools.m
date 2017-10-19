//
//  WWTools.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWTools.h"

@implementation WWTools

+ (NSDictionary *)combinedParamsForRequestWithSearchUrl:(NSString *)searchUrl replaceString:(NSString *)replaceString
{
    NSString *fullUrl = [searchUrl stringByReplacingOccurrencesOfString:replaceString withString:@""];
    NSRange segRange = [fullUrl rangeOfString:@"?"];
    NSString *searchMethod = [fullUrl substringToIndex:segRange.location];
    NSString *paramsStr = [fullUrl substringFromIndex:segRange.location+1];
    NSDictionary *params = [paramsStr paramStringToDictionary];
    NSDictionary *searchParams = params;
    return [NSDictionary dictionaryWithObject:searchParams forKey:searchMethod];
}

@end
