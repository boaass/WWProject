//
//  KOGRequestGenerator.m
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGRequestGenerator.h"
#import "AFNetworking.h"
#import "KOGNetworkingConfiguration.h"
#import "KOGService.h"
#import "KOGServiceFactory.h"
#import "NSURLRequest+KOGNetworking.h"

@implementation KOGRequestGenerator

+ (AFHTTPRequestSerializer *)httpRequestSerializer
{
    AFHTTPRequestSerializer *httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    httpRequestSerializer.timeoutInterval = kKOGNetworkingTimeoutSeconds;
    httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    return httpRequestSerializer;
}

+ (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    KOGService *service = [[KOGServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *URLString = methodName.length==0?service.apiBaseUrl : [service.apiBaseUrl stringByAppendingPathComponent:methodName];
    
    AFHTTPRequestSerializer *serializer = [KOGRequestGenerator httpRequestSerializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:URLString parameters:requestParams error:nil];
    request.requestParams = requestParams;
    [request setAllHTTPHeaderFields:service.allHTTPHeaderFields];
    return request;
}

+ (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    KOGService *service = [[KOGServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *URLString = methodName.length==0?service.apiBaseUrl : [service.apiBaseUrl stringByAppendingPathComponent:methodName];
    
    AFHTTPRequestSerializer *serializer = [KOGRequestGenerator httpRequestSerializer];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:URLString parameters:requestParams error:nil];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    request.requestParams = requestParams;
    [request setAllHTTPHeaderFields:service.allHTTPHeaderFields];
    return request;
}

+ (NSURLRequest *)generatePutRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    KOGService *service = [[KOGServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *URLString = methodName.length==0?service.apiBaseUrl : [service.apiBaseUrl stringByAppendingPathComponent:methodName];
    
    AFHTTPRequestSerializer *serializer = [KOGRequestGenerator httpRequestSerializer];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"PUT" URLString:URLString parameters:requestParams error:nil];
    [request setAllHTTPHeaderFields:service.allHTTPHeaderFields];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    request.requestParams = requestParams;
    return request;
}

+ (NSURLRequest *)generateDeleteRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName
{
    KOGService *service = [[KOGServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    NSString *URLString = methodName.length==0?service.apiBaseUrl : [service.apiBaseUrl stringByAppendingPathComponent:methodName];
    
    AFHTTPRequestSerializer *serializer = [KOGRequestGenerator httpRequestSerializer];
    
    NSMutableURLRequest *request = [serializer requestWithMethod:@"DELETE" URLString:URLString parameters:requestParams error:nil];
    request.requestParams = requestParams;
    [request setAllHTTPHeaderFields:service.allHTTPHeaderFields];
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:requestParams options:0 error:NULL];
    return request;
}

@end
