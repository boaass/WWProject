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
        NSLog(@"model: %@", model);
    }
    
    // 获取标签信息
    NSString *baseTagUrl = @"http://weixin.sogou.com/pcindex/pc";
    NSArray *tagItems1 = [hpple searchWithXPathQuery:@"//div[@class='fieed-box']/a"];
    NSArray *tagItems2 = [hpple searchWithXPathQuery:@"//div[@class='tab-box-pop']/a"];
    NSArray *tagItems = [tagItems1 arrayByAddingObjectsFromArray:tagItems2];
    NSMutableDictionary *tags = [NSMutableDictionary dictionary];
    for (TFHppleElement *element in tagItems) {
        NSString *tag = [element text];
        NSString *pcIndex = [element objectForKey:@"id"];
        if ([pcIndex isEqualToString:@"more_anchor"]) {
            continue;
        }
        NSString *url = [[baseTagUrl stringByAppendingPathComponent:pcIndex] stringByAppendingPathComponent:pcIndex];
        [tags setObject:url forKey:tag];
    }
    
    // 热词
    
    WWMainPageModel *model = [[WWMainPageModel alloc] init];
    model.carouselImages = [carouselImages copy];
    model.tags = [tags copy];
    
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
