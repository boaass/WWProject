//
//  WWArticleSearchAPIManager.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/13.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWArticleSearchAPIManager.h"
#import "KOGNetworkingConfiguration.h"
#import "TFHpple.h"
#import "WWArticleItemModel.h"

@interface WWArticleSearchAPIManager () <KOGAPIManager, KOGAPIManagerParamSource, KOGAPIManagerCallBackDelegate>

@property (nonatomic, strong, readwrite) NSArray <WWArticleItemModel *> *articleInfos;
@property (nonatomic, strong, readwrite) NSString *method;
@property (nonatomic, strong, readwrite) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *nextParams;
@property (nonatomic, strong) ArticleInfoCompleteBlock block;

@end

@implementation WWArticleSearchAPIManager

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
- (void)loadDataWithUrl:(NSString *)methodName params:(NSDictionary *)params block:(ArticleInfoCompleteBlock)block
{
    self.method = methodName;
    self.params = params;
    self.block = block;
    [self loadData];
}

- (void)nextPage:(ArticleInfoCompleteBlock)block
{
    [self loadDataWithUrl:self.method params:self.nextParams block:^(WWArticleSearchAPIManager *manager) {
        if (block) {
            block(manager);
        }
    }];
}

#pragma mark - KOGAPIManager
- (NSString *)methodName
{
    return self.method;
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
    return self.params;
}

#pragma mark - KOGAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(KOGAPIBaseManager *)manager
{
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:manager.response.responseData];
    NSString *nextParamsStr = [[hpple peekAtSearchWithXPathQuery:@"//a[@class='np']"] objectForKey:@"href"];
    NSString *parseStr = [nextParamsStr hasPrefix:@"?"] ? [nextParamsStr substringFromIndex:1]:nextParamsStr;
    self.nextParams = [parseStr paramStringToDictionary];
    
    NSArray *liElements = [hpple searchWithXPathQuery:@"//ul[@class='news-list']/li"];
    NSMutableArray <WWArticleItemModel *> *articleInfos = [NSMutableArray array];
    for (TFHppleElement *element in liElements) {
        TFHpple *liHpple = [[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
        TFHppleElement *imageElement = [liHpple peekAtSearchWithXPathQuery:@"//img"];
        NSString *bigImageUrl = [imageElement objectForKey:@"src"];
        TFHppleElement *titleElement = [liHpple peekAtSearchWithXPathQuery:@"//h3/a"];
        NSString *contentUrl = [titleElement objectForKey:@"href"];
        NSString *title = [[titleElement texts] componentsJoinedByString:@""];
        TFHppleElement *accountElement = [liHpple peekAtSearchWithXPathQuery:@"//a[@class='account']"];
        NSString *authorMainUrl = [accountElement objectForKey:@"href"];
        NSString *author = [accountElement text];
        TFHppleElement *timeElement = [liHpple peekAtSearchWithXPathQuery:@"//span[@class='s2']"];
        NSString *timeStamp = [timeElement objectForKey:@"t"];
        TFHppleElement *overviewElement = [liHpple peekAtSearchWithXPathQuery:@"//p[@class='txt-info']"];
        NSString *overview = [overviewElement text];
        
        WWArticleItemModel *model = [[WWArticleItemModel alloc] init];
        model.title = title;
        model.bigImageUrl = bigImageUrl;
        model.contentUrl = contentUrl;
        model.authorMainUrl = authorMainUrl;
        model.author = author;
        model.timeStamp = timeStamp;
        model.overview = overview;
        [articleInfos addObject:model];
    }
    self.articleInfos = [articleInfos copy];
    
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
