//
//  WWArticleInfoManager.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWArticleInfoManager.h"
#import "KOGNetworkingConfiguration.h"

@interface WWArticleInfoManager () <KOGAPIManager, KOGAPIManagerParamSource, KOGAPIManagerCallBackDelegate>

@property (nonatomic, strong, readwrite) NSArray <WWArticleItemModel *> *articleInfo;
@property (nonatomic, strong, readwrite) NSString *methodName;
@property (nonatomic, strong) CompleteBlock block;

@end

@implementation WWArticleInfoManager

#pragma mark - life circle
- (instancetype)init
{
    if (self = [super init]) {
        self.delegate = self;
        self.paramSource = self;
    }
    
    return self;
}

#pragma mark - public
- (void)loadDataWithUrl:(NSString *)methodName block:(CompleteBlock)block
{
    self.methodName = methodName;
    self.block = block;
}

- (void)nextPage
{
    
}

#pragma mark - KOGAPIManager
- (NSString *)methodName
{
    return self.methodName;
}

- (NSString *)serviceType
{
    return kWWMainPageService;
}

- (KOGAPIManagerRequestType)requestType
{
    return KOGAPIManagerRequestTypeGet;
}

#pragma mark - KOGAPIManagerParamSource
- (NSDictionary *)paramsForApi:(KOGAPIBaseManager *)mamanger
{
    return nil;
}

#pragma mark - KOGAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(KOGAPIBaseManager *)manager
{
    
    if (self.block) {
        self.block(self);
    }
    NSLog(@"success");
}

- (void)managerCallAPIDidFailed:(KOGAPIBaseManager *)manager
{
    if (self.block) {
        self.block(self);
    }
    NSLog(@"failed");
}

@end
