//
//  WWArticleInAccountMainPageAPIManager.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/19.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWAccountMainPageAPIManager.h"
#import "KOGNetworkingConfiguration.h"
#import "TFHpple.h"
#import "WWArticleItemModel.h"
#import "WWAccountModel.h"

@interface WWAccountMainPageAPIManager () <KOGAPIManager, KOGAPIManagerParamSource, KOGAPIManagerCallBackDelegate>

@property (nonatomic, strong, readwrite) NSArray <WWArticleItemModel *> *articleInfos;
@property (nonatomic, strong, readwrite) WWAccountModel *accountInfo;
@property (nonatomic, strong, readwrite) NSString *method;
@property (nonatomic, strong, readwrite) NSDictionary *params;

@property (nonatomic, strong) AccountMainPageInfoCompleteBlock block;

@end

@implementation WWAccountMainPageAPIManager

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
- (void)loadDataWithUrl:(NSString *)methodName params:(NSDictionary *)params block:(AccountMainPageInfoCompleteBlock)block
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
    return kWWWXService;
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
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:manager.response.responseData];
    // 解析获取 WWAccountModel
    NSString *iconUrl = [[hpple peekAtSearchWithXPathQuery:@"//span[@class='radius_avatar profile_avatar']/img"] objectForKey:@"src"];
    NSString *author = [[[hpple peekAtSearchWithXPathQuery:@"//strong[@class='profile_nickname']"] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *wxID = [[[[hpple peekAtSearchWithXPathQuery:@"//p[@class='profile_account']"] text] componentsSeparatedByString:@":"] lastObject];
    NSMutableArray *descriptions = [NSMutableArray array];
    NSArray *liElements = [hpple searchWithXPathQuery:@"//ul[@class='profile_desc']/li"];
    for (TFHppleElement *element in liElements) {
        TFHpple *elementHpple = [[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *label = [[elementHpple peekAtSearchWithXPathQuery:@"//label[@class='profile_desc_label']"] text];
        NSString *value = [[elementHpple peekAtSearchWithXPathQuery:@"//div[@class='profile_desc_value']"] text];
        [descriptions addObject:[NSDictionary dictionaryWithObject:value forKey:label]];
    }
    WWAccountModel *accountModel = [[WWAccountModel alloc] init];
    accountModel.iconUrl = iconUrl;
    accountModel.author = author;
    accountModel.wxID = wxID;
    accountModel.authorMainUrl = self.authorMainPageUrl;
    accountModel.descriptions = [descriptions copy];
    self.accountInfo = accountModel;
    
    // 解析获取 articleInfos
    NSArray *infos = [hpple searchWithXPathQuery:@"//div[@class='weui_msg_card_list']/div[@class='weui_msg_card']"];
    for (TFHppleElement *element in infos) {
        TFHpple *elementHpple = [[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
        TFHppleElement *iconElement = [elementHpple peekAtSearchWithXPathQuery:@"//span[@class='weui_media_hd']"];
        NSString *timeStamp = [iconElement objectForKey:@"data-t"];
        NSString *style = [iconElement objectForKey:@"style"];
        NSRange range = [style rangeOfString:@"("];
        NSString *bigImageUrl = [[style substringFromIndex:range.location+1] stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSString *contentUrl = [kWWWXServiceOnlineApiBaseUrl stringByAppendingPathComponent:[iconElement objectForKey:@"hrefs"]];
        NSString *title = [[[elementHpple peekAtSearchWithXPathQuery:@"//h4[@class='weui_media_title']"] text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *overview = [[elementHpple peekAtSearchWithXPathQuery:@"//p[@class='weui_media_desc']"] text];
        
        WWArticleItemModel *articleModel = [[WWArticleItemModel alloc] init];
        articleModel.timeStamp = timeStamp;
        articleModel.bigImageUrl = bigImageUrl;
        articleModel.contentUrl = contentUrl;
        articleModel.title = title;
        articleModel.overview = overview;
        articleModel.author = author;
        articleModel.authorMainUrl = self.authorMainPageUrl;
    }
    
    if (self.block) {
        self.block(self);
    }
}

- (void)managerCallAPIDidFailed:(KOGAPIBaseManager *)manager
{
    if (self.block) {
        self.block(self);
    }
    NSLog(@"failed");
}

@end
