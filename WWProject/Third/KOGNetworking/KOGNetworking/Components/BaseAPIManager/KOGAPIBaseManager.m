//
//  KOGAPIBaseManager.m
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/8.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "KOGAPIBaseManager.h"
#import "KOGAPIProxy.h"
#import "KOGAppContext.h"
#import "KOGURLResponse.h"

#define KOGCallAPI(REQUEST_METHOD, REQUEST_ID)                                                   \
{                                                                                               \
    __weak typeof(self) weakSelf = self;                                                        \
    REQUEST_ID = [[KOGAPIProxy sharedInstance] call##REQUEST_METHOD##WithParams:apiParams serviceIdentifier:self.child.serviceType methodName:self.child.methodName success:^(KOGURLResponse *response) { \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf successedOnCallingAPI:response];                                            \
    } fail:^(KOGURLResponse *response) {                                                        \
        __strong typeof(weakSelf) strongSelf = weakSelf;                                        \
        [strongSelf failedOnCallingAPI:response withErrorType:KOGAPIManagerErrorTypeTimeout];    \
    }];                                                                                         \
    [self.requestIdList addObject:@(REQUEST_ID)];                                               \
}

#define kKOGAPIBaseManagerException @"k_kog_api_base_manager_exception"
const NSString * const kKOGAPIBaseManagerRequestID = @"k_kog_api_base_manager_requestID";

@interface KOGAPIBaseManager ()

@property (nonatomic, strong, readwrite) id fetchedRawData;
@property (nonatomic, assign, readwrite) BOOL isLoading;

@property (nonatomic, strong, readwrite) NSError *error;
@property (nonatomic, readwrite) KOGAPIManagerErrorType errorType;
@property (nonatomic, strong) NSMutableArray *requestIdList;

@end

@implementation KOGAPIBaseManager

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.errorType = KOGAPIManagerErrorTypeDefault;
        if ([self conformsToProtocol:@protocol(KOGAPIManager)]) {
            self.child = (id<KOGAPIManager>)self;
        } else {
            NSException *exception = [NSException exceptionWithName:kKOGAPIBaseManagerException reason:@"Subclass for 'KOGAPIBaseManager' need comform to @protocol(KOGAPIManager) !!!" userInfo:nil];
            @throw exception;
        }
    }
    
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
    self.requestIdList = nil;
}

#pragma mark - publice
- (NSInteger)loadData
{
    NSDictionary *param = nil;
    if ([self.paramSource respondsToSelector:@selector(paramsForApi:)]) {
        param = [self.paramSource paramsForApi:self];
    }
         
    NSInteger requestID = [self kog_loadDataWithParams:param];
    
    return requestID;
}

- (id)fetchDataWithReformer:(id<KOGAPIManagerDataReformer>)reformer
{
    id resultData = nil;
    if ([reformer respondsToSelector:@selector(manager:reformData:)]) {
        resultData = [reformer manager:self reformData:self.fetchedRawData];
    } else {
        resultData = [self.fetchedRawData mutableCopy];
    }
    
    return resultData;
}

- (void)cancelAllRequests
{
    [[KOGAPIProxy sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestIdList removeAllObjects];
}

- (void)cancelRequestWithRequestID:(NSInteger)requestID
{
    [[KOGAPIProxy sharedInstance] cancelRequestWithRequestID:@(requestID)];
    [self kog_removeRequestIdWithRequestID:requestID];
}

- (void)cleanData
{
    self.fetchedRawData = nil;
    self.error = nil;
    self.errorType = KOGAPIManagerErrorTypeDefault;
}

#pragma mark - api callbacks
- (void)successedOnCallingAPI:(KOGURLResponse *)response
{
    self.isLoading = NO;
    self.response = response;
    
    if (response.content) {
        self.fetchedRawData = [response.content copy];
    } else {
        self.fetchedRawData = [response.responseData copy];
    }
    
    [self kog_removeRequestIdWithRequestID:response.requestId];
    
    if ([self kog_isCorrectWithCallBackData:response.content]) {
        
        if ([self kog_beforePerformSuccessWithResponse:response]) {
            if ([self.delegate respondsToSelector:@selector(managerCallAPIDidSuccess:)]) {
                [self.delegate managerCallAPIDidSuccess:self];
            }
        }
        
        [self kog_afterPerformSuccessWithResponse:response];
    } else {
        
        [self failedOnCallingAPI:response withErrorType:KOGAPIManagerErrorTypeNoContent];
    }
}

- (void)failedOnCallingAPI:(KOGURLResponse *)response withErrorType:(KOGAPIManagerErrorType)errorType
{
    self.isLoading = NO;
    self.response = response;
    self.errorType = errorType;
    self.error = response.error;
    
    [self kog_removeRequestIdWithRequestID:response.requestId];
    if ([self kog_beforePerformFailWithResponse:response]) {
        if ([self.delegate respondsToSelector:@selector(managerCallAPIDidFailed:)]) {
            [self.delegate managerCallAPIDidFailed:self];
        }
        [self kog_afterPerformFailWithResponse:response];
    }
}

#pragma mark - private
- (NSInteger)kog_loadDataWithParams:(NSDictionary *)param
{
    NSInteger requestID = 0;
    
    NSDictionary *apiParams = param;
    if ([self.child respondsToSelector:@selector(reformParams:)]) {
        apiParams = [self.child reformParams:param];
    }
    
    if ([self kog_shouldCallAPIWithParams:apiParams]) {
        if ([self kog_isCorrectWithParamsData:apiParams]) {
            if (self.isReachable) {
                self.isLoading = YES;
                switch (self.child.requestType) {
                    case KOGAPIManagerRequestTypeGet:
                        KOGCallAPI(GET, requestID)
                        break;
                    case KOGAPIManagerRequestTypePost:
                        KOGCallAPI(POST, requestID)
                        break;
                    case KOGAPIManagerRequestTypePut:
                        KOGCallAPI(PUT, requestID);
                        break;
                    case KOGAPIManagerRequestTypeDelete:
                        KOGCallAPI(DELETE, requestID);
                        break;
                }
                
                NSMutableDictionary *params = [apiParams mutableCopy];
                params[kKOGAPIBaseManagerRequestID] = @(requestID);
                [self kog_afterCallingAPIWithParams:params];
                
            } else {
                
                [self failedOnCallingAPI:nil withErrorType:KOGAPIManagerErrorTypeNoNetWork];
            }
        } else {
            
            [self failedOnCallingAPI:nil withErrorType:KOGAPIManagerErrorTypeParamsError];
        }
        
    }
    
    return requestID;
}

- (void)kog_removeRequestIdWithRequestID:(NSInteger)requestID
{
    for (NSNumber *storedRequestId in self.requestIdList) {
        if ([storedRequestId integerValue] == requestID) {
            [self.requestIdList removeObject:storedRequestId];
        }
    }
}

// KOGAPIManagerInterceptor
- (BOOL)kog_shouldCallAPIWithParams:(NSDictionary *)params
{
    if (self.interceptor && [self.interceptor respondsToSelector:@selector(manager:shouldCallAPIWithParams:)]) {
        return [self.interceptor manager:self shouldCallAPIWithParams:params];
    } else {
        return YES;
    }
}

- (void)kog_afterCallingAPIWithParams:(NSDictionary *)params
{
    if (self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterCallingAPIWithParams:)]) {
        [self.interceptor manager:self afterCallingAPIWithParams:params];
    }
}

- (BOOL)kog_beforePerformSuccessWithResponse:(KOGURLResponse *)response
{
    if (self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformSuccessWithResponse:)]) {
        return [self.interceptor manager:self beforePerformSuccessWithResponse:response];
    } else {
        return YES;
    }
}

- (void)kog_afterPerformSuccessWithResponse:(KOGURLResponse *)response
{
    if (self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformSuccessWithResponse:)]) {
        [self.interceptor manager:self afterPerformSuccessWithResponse:response];
    }
}

- (BOOL)kog_beforePerformFailWithResponse:(KOGURLResponse *)response
{
    if (self.interceptor && [self.interceptor respondsToSelector:@selector(manager:beforePerformFailWithResponse:)]) {
        return [self.interceptor manager:self beforePerformFailWithResponse:response];
    } else {
        return YES;
    }
}

- (void)kog_afterPerformFailWithResponse:(KOGURLResponse *)response
{
    if (self.interceptor && [self.interceptor respondsToSelector:@selector(manager:afterPerformFailWithResponse:)]) {
        [self.interceptor manager:self afterPerformFailWithResponse:response];
    }
}

// KOGAPIManagerValidator
- (BOOL)kog_isCorrectWithParamsData:(NSDictionary *)data
{
    if (self.validator && [self.validator respondsToSelector:@selector(manager:isCorrectWithParamsData:)]) {
        return [self.validator manager:self isCorrectWithParamsData:data];
    } else {
        return YES;
    }
}

- (BOOL)kog_isCorrectWithCallBackData:(NSDictionary *)data
{
    if (self.validator && [self.validator respondsToSelector:@selector(manager:isCorrectWithCallBackData:)]) {
        return [self.validator manager:self isCorrectWithCallBackData:data];
    } else {
        return YES;
    }
}

#pragma mark - setter & getter
- (BOOL)isReachable
{
    BOOL isReachability = [KOGAppContext sharedInstance].isReachable;
    
    if (!isReachability) {
        self.errorType = KOGAPIManagerErrorTypeNoNetWork;
    }
    
    return isReachability;
}

@end
