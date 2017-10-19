//
//  WWWXArticleAPIManager.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWWXArticleAPIManager.h"
#import "KOGNetworkingConfiguration.h"
#import "TFHpple.h"
#import "WWArticleItemModel.h"
#import "WWArticleSearchAPIManager.h"
#import "WWMainPageModel.h"

@interface WWWXArticleAPIManager () <KOGAPIManager, KOGAPIManagerParamSource, KOGAPIManagerCallBackDelegate>

@property (nonatomic, strong, readwrite) WWArticleItemModel *articleInfo;
@property (nonatomic, strong, readwrite) NSString *method;
@property (nonatomic, strong, readwrite) NSDictionary *params;
@property (nonatomic, strong) WXArticleInfoCompleteBlock block;
@property (nonatomic, strong) WWArticleSearchAPIManager *articleSearchManager;

@end

@implementation WWWXArticleAPIManager

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
- (void)loadDataWithUrl:(NSString *)methodName params:(NSDictionary *)params block:(WXArticleInfoCompleteBlock)block
{
    self.method = methodName;
    self.params = params;
    self.block = block;
    [self loadData];
}

#pragma mark - KOGAPIManager
- (NSString *)methodName
{
    return self.method;
}

- (NSString *)serviceType
{
    return kWWAccountMainPageService;
}

- (KOGAPIManagerRequestType)requestType
{
    return KOGAPIManagerRequestTypeGet;
}

#pragma mark - KOGAPIManagerParamSource
- (NSDictionary *)paramsForApi:(KOGAPIBaseManager *)mamanger
{
    return self.params;
}

#pragma mark - KOGAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(KOGAPIBaseManager *)manager
{
    __weak typeof(self) weakSelf = self;
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:manager.response.responseData];
    NSString *title = [[hpple peekAtSearchWithXPathQuery:@"//title"] text];
    NSString *fullUrl = [[[WWMainPageModel sharedInstance].articleSearchUrl stringByReplacingOccurrencesOfString:kWWMainPageServiceOnlineApiBaseUrl withString:@""] stringByAppendingString:title];
    NSDictionary *requestData = [WWTools combinedParamsForRequestWithSearchUrl:fullUrl replaceString:kWWMainPageServiceOnlineApiBaseUrl];
    [self.articleSearchManager loadDataWithUrl:[[requestData allKeys] firstObject] params:[[requestData allValues] firstObject] block:^(WWArticleSearchAPIManager *manager) {
        if (manager.errorType == KOGAPIManagerErrorTypeSuccess) {
            weakSelf.articleInfo = [manager.articleInfos firstObject];
        }
        self.block(weakSelf);
    }];
}

- (void)managerCallAPIDidFailed:(KOGAPIBaseManager *)manager
{
    if (self.block) {
        self.block(self);
    }
    NSLog(@"failed");
}

#pragma mark - setter & getter
- (WWArticleSearchAPIManager *)articleSearchManager
{
    if (!_articleSearchManager) {
        _articleSearchManager = [[WWArticleSearchAPIManager alloc] init];
    }
    return _articleSearchManager;
}

@end
