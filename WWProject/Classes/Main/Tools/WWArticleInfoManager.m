//
//  WWArticleInfoManager.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/9.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWArticleInfoManager.h"
#import "KOGNetworkingConfiguration.h"
#import "TFHpple.h"
#import "WWArticleItemModel.h"

@interface WWArticleInfoManager () <KOGAPIManager, KOGAPIManagerParamSource, KOGAPIManagerCallBackDelegate>

@property (nonatomic, strong, readwrite) NSArray <WWArticleItemModel *> *articleInfo;
@property (nonatomic, strong, readwrite) NSString *method;
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
    self.method = methodName;
    self.block = block;
    
    [self loadData];
}

- (void)nextPage
{
    
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
    return nil;
}

#pragma mark - KOGAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(KOGAPIBaseManager *)manager
{
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:manager.response.responseData];
    NSArray *liElements = [hpple searchWithXPathQuery:@"//li"];
    NSMutableArray <WWArticleItemModel *> *articleInfo = [NSMutableArray array];
    for (TFHppleElement *element in liElements) {
        TFHpple *liHpple = [[TFHpple alloc] initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
        TFHppleElement *imageElement = [liHpple peekAtSearchWithXPathQuery:@"//img"];
        NSString *bigImageUrl = [imageElement objectForKey:@"src"];
        TFHppleElement *titleElement = [liHpple peekAtSearchWithXPathQuery:@"//h3/a"];
        NSString *contentUrl = [titleElement objectForKey:@"href"];
        NSString *title = [titleElement text];
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
        [articleInfo addObject:model];
    }
    self.articleInfo = [articleInfo copy];
    
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
