//
//  KOGServiceFactory.m
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGServiceFactory.h"
#import "WWMainPageService.h"
#import "KOGNetworkingConfiguration.h"

NSString * const kWWMainPageService = @"kWWMainPageService";
NSString * const kWWMainPageServiceOfflineApiBaseUrl = @"http://weixin.sogou.com/";
NSString * const kWWMainPageServiceOnlineApiBaseUrl = @"http://weixin.sogou.com/";

@interface KOGServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end

@implementation KOGServiceFactory

+ (instancetype)sharedInstance
{
    static KOGServiceFactory *m_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_instance = [[KOGServiceFactory alloc] init];
    });
    
    return m_instance;
}

- (KOGService<KOGServiceProtocol> *)serviceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil) {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

#pragma mark - private methods
- (KOGService<KOGServiceProtocol> *)newServiceWithIdentifier:(NSString *)identifier
{
#warning 注册服务
    if ([identifier isEqualToString:kWWMainPageService]) {
        return [[WWMainPageService alloc] init];
    }
    
    return nil;
}

#pragma mark - getters and setters
- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil) {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

@end
