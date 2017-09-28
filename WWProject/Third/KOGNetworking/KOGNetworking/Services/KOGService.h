//
//  KOGService.h
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KOGServiceProtocol <NSObject>

@property (nonatomic, readonly) BOOL isOnline;

@property (nonatomic, readonly) NSString *offlineApiBaseUrl;
@property (nonatomic, readonly) NSString *onlineApiBaseUrl;

@property (nonatomic, readonly) NSDictionary <NSString *, NSString *> *allHTTPHeaderFields;

@end

@interface KOGService : NSObject

@property (nonatomic, strong, readonly) NSString *apiBaseUrl;

@property (nonatomic, strong, readonly) NSDictionary <NSString *, NSString *> *allHTTPHeaderFields;

@property (nonatomic, weak) id<KOGServiceProtocol> child;

@end
