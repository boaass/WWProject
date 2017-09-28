//
//  KOGService.m
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGService.h"

#define kKOGServiceException       @"k_kog_service_exception"

@implementation KOGService

- (instancetype)init
{
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(KOGServiceProtocol)]) {
            self.child = (id<KOGServiceProtocol>)self;
        } else {
            NSException *exception = [NSException exceptionWithName:kKOGServiceException reason:@"Subclass for 'KOGService' need comform to @protocol(KOGServiceProtocol) !!!" userInfo:nil];
            @throw exception;
        }
    }
    
    return self;
}

#pragma mark - getter & setter
- (NSString *)apiBaseUrl
{
    return self.child.isOnline ? self.child.onlineApiBaseUrl : self.child.offlineApiBaseUrl;
}

- (NSDictionary <NSString *, NSString *> *)allHTTPHeaderFields
{
    return self.child.allHTTPHeaderFields;
}

@end
