//
//  WWMainPageService.m
//  WWProject
//
//  Created by zhai chunlin on 17/9/28.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWMainPageService.h"
#import "KOGAppContext.h"
#import "KOGNetworkingConfiguration.h"

@interface WWMainPageService () <KOGServiceProtocol>

@end

@implementation WWMainPageService

- (BOOL)isOnline
{
    return [KOGAppContext sharedInstance].isOnline;
}

- (NSString *)offlineApiBaseUrl
{
    return kWWMainPageServiceOfflineApiBaseUrl;
}

- (NSString *)onlineApiBaseUrl
{
    return kWWMainPageServiceOnlineApiBaseUrl;
}

- (NSDictionary<NSString *,NSString *> *)allHTTPHeaderFields
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.100 Safari/537.36", @"User-Agent", nil];
}

@end
