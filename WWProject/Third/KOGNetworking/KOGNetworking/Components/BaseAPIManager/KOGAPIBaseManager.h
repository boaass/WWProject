//
//  KOGAPIBaseManager.h
//  KOGNetworking
//
//  Created by zcl_kingsoft on 2017/3/8.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KOGURLResponse.h"

@class KOGAPIBaseManager;

extern const NSString * const kKOGAPIBaseManagerRequestID;

/*
 ** 请求相关枚举类型
 */
typedef NS_ENUM (NSUInteger, KOGAPIManagerErrorType){
    KOGAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    KOGAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    KOGAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    KOGAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    KOGAPIManagerErrorTypeTimeout,       //请求超时。CTAPIProxy设置的是20秒超时，具体超时时间的设置请自己去看CTAPIProxy的相关代码。
    KOGAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};

typedef NS_ENUM (NSUInteger, KOGAPIManagerRequestType){
    KOGAPIManagerRequestTypeGet,
    KOGAPIManagerRequestTypePost,
    KOGAPIManagerRequestTypePut,
    KOGAPIManagerRequestTypeDelete
};

/*************************************************************************************************/
/*                                         KOGAPIManager                                          */
/*************************************************************************************************/
/*
 ** KOGAPIBaseManager的派生类必须符合这些protocal
 */
@protocol KOGAPIManager <NSObject>

@required
- (NSString *)methodName;
- (NSString *)serviceType;
- (KOGAPIManagerRequestType)requestType;

@optional
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSInteger)loadDataWithParams:(NSDictionary *)params;

@end


/*************************************************************************************************/
/*                                KOGAPIManagerParamSource                                */
/*************************************************************************************************/
@protocol KOGAPIManagerParamSource <NSObject>

@required
- (NSDictionary *)paramsForApi:(KOGAPIBaseManager *)mamanger;

@end


/*************************************************************************************************/
/*                                     KOGAPIManagerValidator                                     */
/*************************************************************************************************/
// 用于校验API的返回或者调用API的参数是否正确
@protocol KOGAPIManagerValidator <NSObject>

@required
// 校验调用API的数据格式
- (BOOL)manager:(KOGAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;

// 校验API返回的数据格式
- (BOOL)manager:(KOGAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

@end
 

/*************************************************************************************************/
/*                               KOGAPIManagerApiCallBackDelegate                                 */
/*************************************************************************************************/

// API回调
@protocol KOGAPIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(KOGAPIBaseManager *)manager;
- (void)managerCallAPIDidFailed:(KOGAPIBaseManager *)manager;
@end

/*************************************************************************************************/
/*                                    KOGAPIManagerInterceptor                                    */
/*************************************************************************************************/
/*
 ** KOGAPIBaseManager的派生类必须符合这些protocal
 */
@protocol KOGAPIManagerInterceptor <NSObject>

@optional
// 请求前
- (BOOL)manager:(KOGAPIBaseManager *)manager shouldCallAPIWithParams:(NSDictionary *)params;
- (void)manager:(KOGAPIBaseManager *)manager afterCallingAPIWithParams:(NSDictionary *)params;

// 请求后
- (BOOL)manager:(KOGAPIBaseManager *)manager beforePerformSuccessWithResponse:(KOGURLResponse *)response;
- (void)manager:(KOGAPIBaseManager *)manager afterPerformSuccessWithResponse:(KOGURLResponse *)response;

- (BOOL)manager:(KOGAPIBaseManager *)manager beforePerformFailWithResponse:(KOGURLResponse *)response;
- (void)manager:(KOGAPIBaseManager *)manager afterPerformFailWithResponse:(KOGURLResponse *)response;

@end

/*************************************************************************************************/
/*                                     KOGAPIManagerDataReformer                                        */
/*************************************************************************************************/
@protocol KOGAPIManagerDataReformer <NSObject>

@required
- (id)manager:(KOGAPIBaseManager *)manager reformData:(NSDictionary *)data;

@end


/*************************************************************************************************/
/*                                       KOGAPIBaseManager                                        */
/*************************************************************************************************/
@interface KOGAPIBaseManager : NSObject

@property (nonatomic, weak) NSObject<KOGAPIManager> *child;
@property (nonatomic, weak) id<KOGAPIManagerParamSource> paramSource;
@property (nonatomic, weak) id<KOGAPIManagerValidator> validator;
@property (nonatomic, weak) id<KOGAPIManagerCallBackDelegate> delegate;
@property (nonatomic, weak) id<KOGAPIManagerInterceptor> interceptor;

@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, assign, readonly) KOGAPIManagerErrorType errorType;
@property (nonatomic, strong) KOGURLResponse *response;

@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, assign, readonly) BOOL isReachable;

/**
 *  数据解析
 */
- (id)fetchDataWithReformer:(id<KOGAPIManagerDataReformer>)reformer;

/**
 *  请求
 *  @retrun     返回requestID
 */
- (NSInteger)loadData;

/**
 *  取消全部请求
 */
- (void)cancelAllRequests;

/**
 *  取消指定请求
 *  @param  requestID   对应请求的唯一标记
 */
- (void)cancelRequestWithRequestID:(NSInteger)requestID;

/**
 *  清除
 */
- (void)cleanData;

@end
