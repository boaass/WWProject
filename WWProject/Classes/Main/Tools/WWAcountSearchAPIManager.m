//
//  WWAcountSearchAPIManager.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWAcountSearchAPIManager.h"
#import "KOGNetworkingConfiguration.h"
#import "WWAcountModel.h"
#import "TFHpple.h"

@interface WWAcountSearchAPIManager ()<KOGAPIManager, KOGAPIManagerParamSource, KOGAPIManagerCallBackDelegate>

@property (nonatomic, strong, readwrite) NSArray <WWAcountModel *> *accountInfos;
@property (nonatomic, strong, readwrite) NSString *method;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) NSString *nextPageMethod;
@property (nonatomic, strong) CompleteBlock block;

@end

@implementation WWAcountSearchAPIManager

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
    NSMutableArray *comStrArr = [NSMutableArray arrayWithArray:[self.method componentsSeparatedByString:@"/"]];
    NSString *rStr = [self.method stringByReplacingOccurrencesOfString:@".html" withString:@""];
    self.pageIndex = [[rStr substringFromIndex:rStr.length-1] integerValue];
    [comStrArr replaceObjectAtIndex:comStrArr.count-1 withObject:[NSString stringWithFormat:@"%ld.html", self.pageIndex+1]];
    self.nextPageMethod = [comStrArr componentsJoinedByString:@"/"];
    
    self.block = block;
    
    [self loadData];
}

- (void)nextPage:(CompleteBlock)block
{
    [self loadDataWithUrl:self.nextPageMethod block:^(WWAcountSearchAPIManager *manager) {
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
    return nil;
}

#pragma mark - KOGAPIManagerCallBackDelegate
- (void)managerCallAPIDidSuccess:(KOGAPIBaseManager *)manager
{
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:manager.response.responseData];
    NSArray *accountElements = [hpple searchWithXPathQuery:@"//ul[@class='news-list2']"];
    for (TFHppleElement *element in accountElements) {
        TFHpple *accountHpple = [[TFHpple alloc] initWithXMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *iconUrl = [[accountHpple peekAtSearchWithXPathQuery:@"//img"] objectForKey:@"src"];
        NSString *emAuthor = [[accountHpple peekAtSearchWithXPathQuery:@"//em"] text];
        NSString *suffixAuthor = [[accountHpple peekAtSearchWithXPathQuery:@"//p[@class='tit']/a"] text];
        NSString *author = [emAuthor stringByAppendingString:suffixAuthor];
        NSString *authorMainUrl = [[accountHpple peekAtSearchWithXPathQuery:@"//p[@class='tit']/a"] objectForKey:@"href"];
        NSString *wxID = [[accountHpple peekAtSearchWithXPathQuery:@"//label[@name='em_weixinhao']"] text];
//        NSString *lastMonthArticleNum = ;
        NSArray *dd = [accountHpple peekAtSearchWithXPathQuery:@"//dd"];
        NSString *featureDescription = [[dd objectAtIndex:0] text];
        NSString *wxCertification = [[dd objectAtIndex:1] text];
        NSString *lastArticle = [[dd objectAtIndex:2] text];
        
        WWAcountModel *model = [[WWAcountModel alloc] init];
        model.iconUrl = iconUrl;
        model.author = author;
        model.authorMainUrl = authorMainUrl;
        model.wxID = wxID;
//        model.lastMonthArticleNum = lastMonthArticleNum;
        model.featureDescription = featureDescription;
        model.wxCertification = wxCertification;
        model.lastArticle = lastArticle;
    }
    
//    self.accountInfos = [accountInfos copy];
    
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
