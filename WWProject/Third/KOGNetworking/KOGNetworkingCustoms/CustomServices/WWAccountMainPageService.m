//
//  WWAccountMainPageService.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWAccountMainPageService.h"
#import "KOGAppContext.h"
#import "KOGNetworkingConfiguration.h"

@implementation WWAccountMainPageService

- (BOOL)isOnline
{
    return [KOGAppContext sharedInstance].isOnline;
}

- (NSString *)offlineApiBaseUrl
{
    return kWWAccountMainPageServiceOfflineApiBaseUrl;
}

- (NSString *)onlineApiBaseUrl
{
    return kWWAccountMainPageServiceOnlineApiBaseUrl;
}

- (NSDictionary<NSString *,NSString *> *)allHTTPHeaderFields
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36", @"User-Agent", nil];
}

@end
