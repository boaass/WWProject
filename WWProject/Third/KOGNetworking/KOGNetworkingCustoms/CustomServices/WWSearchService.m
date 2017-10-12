//
//  WWSearchService.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/12.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWSearchService.h"
#import "KOGAppContext.h"
#import "KOGNetworkingConfiguration.h"

@implementation WWSearchService

- (BOOL)isOnline
{
    return [KOGAppContext sharedInstance].isOnline;
}

- (NSString *)offlineApiBaseUrl
{
    return kWWSearchServiceOfflineApiBaseUrl;
}

- (NSString *)onlineApiBaseUrl
{
    return kWWSearchServiceOnlineApiBaseUrl;
}

- (NSDictionary<NSString *,NSString *> *)allHTTPHeaderFields
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36", @"User-Agent", nil];
}

@end
