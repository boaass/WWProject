//
//  NSURLRequest+KOGNetworking.m
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "NSURLRequest+KOGNetworking.h"
#import <objc/runtime.h>

static void *KOGNetworkingRequestParams;

@implementation NSURLRequest (KOGNetworking)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &KOGNetworkingRequestParams, requestParams , OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &KOGNetworkingRequestParams);
}

@end
