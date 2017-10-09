	//
//  WWMainPageAPIManager.m
//  WWProject
//
//  Created by zhai chunlin on 17/9/29.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWMainPageAPIManager.h"
#import "KOGNetworkingConfiguration.h"
#import "TFHpple.h"
#import "WWMainPageModel.h"
#import "WWArticleItemModel.h"
#import "WWHotwordModel.h"

@interface WWMainPageAPIManager () <KOGAPIManager, KOGAPIManagerParamSource, KOGAPIManagerCallBackDelegate>

@property (nonatomic, strong) CompleteBlock block;

@end

@implementation WWMainPageAPIManager

- (instancetype)init
{
    if (self = [super init]) {
        self.delegate = self;
        self.paramSource = self;
    }
    
    return self;
}

- (void)loadDataWithBlock:(CompleteBlock)block
{
    [self loadData];
    self.block = block;
}

#pragma mark - KOGAPIManager
- (NSString *)methodName
{
    return @"";
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
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:manager.response.responseData];
    
    // 获取轮播图信息
    NSArray *carouselItems = [hpple searchWithXPathQuery:@"//a[@class='sd-slider-item']"];
    NSMutableArray *carouselImages = [NSMutableArray array];
    for (TFHppleElement *element in carouselItems) {
        TFHpple *elementHpple = [[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
        WWArticleItemModel *model = [[WWArticleItemModel alloc] init];
        model.title = [element objectForKey:@"title"];
        model.bigImageUrl = [[elementHpple peekAtSearchWithXPathQuery:@"//img"] objectForKey:@"src"];
        model.contentUrl = [[elementHpple peekAtSearchWithXPathQuery:@"//a"] objectForKey:@"href"];
        [carouselImages addObject:model];
    }
    
    // 获取标签信息
    NSString *baseTagUrl = @"pcindex/pc";
    NSArray *tagItems1 = [hpple searchWithXPathQuery:@"//div[@class='fieed-box']/a"];
    NSArray *tagItems2 = [hpple searchWithXPathQuery:@"//div[@class='tab-box-pop']/a"];
    NSArray *tagItems = [tagItems1 arrayByAddingObjectsFromArray:tagItems2];
    NSMutableArray *tags = [NSMutableArray array];
    for (TFHppleElement *element in tagItems) {
        NSString *tag = [element text];
        NSString *pcIndex = [element objectForKey:@"id"];
        if ([pcIndex isEqualToString:@"more_anchor"]) {
            continue;
        }
        NSString *url = [[[baseTagUrl stringByAppendingPathComponent:pcIndex] stringByAppendingPathComponent:pcIndex] stringByAppendingString:@".html"];
        WWMainPageTagModel *model = [[WWMainPageTagModel alloc] init];
        model.tagName = tag;
        model.url = url;
        [tags addObject:model];
    }
    
    // 热词
    NSMutableArray *topwords = [NSMutableArray array];
    NSArray *topwordItems = [hpple searchWithXPathQuery:@"//ol[@id='topwords']/li"];
    for (TFHppleElement *element in topwordItems) {
        TFHpple *elementHpple = [[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
        TFHppleElement *aElement = [elementHpple peekAtSearchWithXPathQuery:@"//a"];
        TFHppleElement *spanElement = [elementHpple peekAtSearchWithXPathQuery:@"//span/span"];
        WWHotwordModel *model = [[WWHotwordModel alloc] init];
        model.title = [aElement objectForKey:@"title"];
        model.contentUrl = [aElement objectForKey:@"href"];
        NSString *percentStr = [[[spanElement objectForKey:@"style"] componentsSeparatedByString:@":"] lastObject];
        model.hotPercent = [[percentStr substringToIndex:[percentStr length]-1] floatValue]/100;
        [topwords addObject:model];
    }
    
    // 搜索
    TFHppleElement *baseUrlElement = [hpple peekAtSearchWithXPathQuery:@"//a[@uigs='search_logo']"];
    NSString *searchBaseUrl = [baseUrlElement objectForKey:@"href"];
    TFHppleElement *actionElement = [hpple peekAtSearchWithXPathQuery:@"//form[@name='searchForm']"];
    NSString *action = [actionElement objectForKey:@"action"];
    NSString *searchUrl = [searchBaseUrl stringByAppendingString:action];
    NSArray *searchParmaElements = [hpple searchWithXPathQuery:@"//div[@class='qborder']/input"];
    NSMutableString *mString = [NSMutableString stringWithFormat:@"%@?", searchUrl];
    for (TFHppleElement *element in searchParmaElements) {
        NSString *name = [element objectForKey:@"name"];
        NSString *value = [element objectForKey:@"value"];
        if (!name || [name isEqualToString:@"query"]) {
            continue;
        }
        if ([name isEqualToString:@"type"]) {
            value = @"SearchType";
        }
        [mString appendFormat:@"%@=%@&", name, value];
    }
    [mString appendString:@"query="];
    
    WWMainPageModel *model = [[WWMainPageModel alloc] init];
    model.carouselImages = [carouselImages copy];
    model.tags = [tags copy];
    model.hotWords = topwords;
    NSString *accountSearchUrl = [mString stringByReplacingOccurrencesOfString:@"SearchType" withString:@"1"];
    model.accountSearchUrl = accountSearchUrl;
    NSString *articleSearchUrl = [mString stringByReplacingOccurrencesOfString:@"SearchType" withString:@"2"];
    model.articleSearchUrl = articleSearchUrl;
    self.model = model;
    
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
