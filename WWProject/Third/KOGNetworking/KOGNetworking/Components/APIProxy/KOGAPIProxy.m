//
//  KOGAPIProxy.m
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/8.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGAPIProxy.h"
#import "AFNetworking.h"
#import "KOGRequestGenerator.h"

@interface KOGAPIProxy ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;

@end

@implementation KOGAPIProxy

#pragma mark - life cycle
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static KOGAPIProxy *m_instance = nil;
    dispatch_once(&onceToken, ^{
        m_instance = [[KOGAPIProxy alloc] init];
    });
    
    return m_instance;
}

#pragma mark - publice
- (NSInteger)callGETWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(KOGCallback)success fail:(KOGCallback)fail
{
    NSURLRequest *request = [KOGRequestGenerator generateGETRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestID = [self kog_callAPIWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}

- (NSInteger)callPOSTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(KOGCallback)success fail:(KOGCallback)fail
{
    NSURLRequest *request = [KOGRequestGenerator generatePOSTRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestID = [self kog_callAPIWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}

- (NSInteger)callPUTWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(KOGCallback)success fail:(KOGCallback)fail
{
    NSURLRequest *request = [KOGRequestGenerator generatePutRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestID = [self kog_callAPIWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}

- (NSInteger)callDELETEWithParams:(NSDictionary *)params serviceIdentifier:(NSString *)servieIdentifier methodName:(NSString *)methodName success:(KOGCallback)success fail:(KOGCallback)fail
{
    NSURLRequest *request = [KOGRequestGenerator generateDeleteRequestWithServiceIdentifier:servieIdentifier requestParams:params methodName:methodName];
    NSNumber *requestID = [self kog_callAPIWithRequest:request success:success fail:fail];
    return [requestID integerValue];
}

- (void)cancelRequestWithRequestID:(NSNumber *)requestID
{
    NSURLSessionDataTask *dataTask = self.dispatchTable[requestID];
    [dataTask cancel];
    [self.dispatchTable removeObjectForKey:requestID];
}

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList
{
    for (NSNumber *requestId in requestIDList) {
        [self cancelRequestWithRequestID:requestId];
    }
}

#pragma mark - private
- (NSNumber *)kog_callAPIWithRequest:(NSURLRequest *)request success:(KOGCallback)success fail:(KOGCallback)fail
{
    __block NSURLSessionDataTask *dataTask = nil;
    __block NSNumber *requestID = nil;
    dataTask = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        requestID = @([dataTask taskIdentifier]);
        [self.dispatchTable removeObjectForKey:requestID];
        NSData *responseData = responseObject;
        NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        
        KOGURLResponse *kogResponse = [[KOGURLResponse alloc] initWithResponseString:responseString requestID:requestID request:request responseData:responseData error:error];
        if (error) {
            fail?fail(kogResponse) : nil;
        } else {
            success?success(kogResponse) : nil;
        }
    }];
    requestID = @([dataTask taskIdentifier]);
    self.dispatchTable[requestID] = dataTask;
    [dataTask resume];
    
    return requestID;
}

#pragma mark - setter & getter
- (AFHTTPSessionManager *)sessionManager
{
    if (_sessionManager == nil) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _sessionManager.securityPolicy.allowInvalidCertificates = YES;
        _sessionManager.securityPolicy.validatesDomainName = NO;
    }
    return _sessionManager;
}

- (NSMutableDictionary *)dispatchTable
{
    if (!_dispatchTable) {
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

@end
