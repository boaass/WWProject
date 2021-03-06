//
//  WWAccountSearchAPIManager.m
//  WWProject
//
//  Created by zcl_kingsoft on 2017/10/11.
//  Copyright © 2017年 zcl_kingsoft. All rights reserved.
//

#import "WWAccountSearchAPIManager.h"
#import "KOGNetworkingConfiguration.h"
#import "WWAccountModel.h"
#import "TFHpple.h"

@interface WWAccountSearchAPIManager ()<KOGAPIManager, KOGAPIManagerParamSource, KOGAPIManagerCallBackDelegate>

@property (nonatomic, strong, readwrite) NSArray <WWAccountModel *> *accountInfos;
@property (nonatomic, strong, readwrite) NSString *method;
@property (nonatomic, strong, readwrite) NSDictionary *params;
@property (nonatomic, strong) NSDictionary *nextParams;
@property (nonatomic, strong) AccountInfoCompleteBlock block;

@end

@implementation WWAccountSearchAPIManager

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
- (void)loadDataWithUrl:(NSString *)methodName params:(NSDictionary *)params block:(AccountInfoCompleteBlock)block
{
    self.method = methodName;
    self.params = params;
    self.block = block;
    [self loadData];
}

- (void)nextPage:(AccountInfoCompleteBlock)block
{
    [self loadDataWithUrl:self.method params:self.nextParams block:^(WWAccountSearchAPIManager *manager) {
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
    NSMutableArray *accountInfos = [NSMutableArray array];
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:manager.response.responseData];
    NSString *nextParamsStr = [[hpple peekAtSearchWithXPathQuery:@"//a[@class='np']"] objectForKey:@"href"];
    NSString *parseStr = [nextParamsStr hasPrefix:@"?"] ? [nextParamsStr substringFromIndex:1]:nextParamsStr;
    self.nextParams = [parseStr paramStringToDictionary];
    
    NSArray *accountElements = [hpple searchWithXPathQuery:@"//ul[@class='news-list2']/li"];
    for (TFHppleElement *element in accountElements) {
        TFHpple *accountHpple = [[TFHpple alloc] initWithXMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
        NSString *iconUrl = [[accountHpple peekAtSearchWithXPathQuery:@"//img"] objectForKey:@"src"];
        NSString *author = [[[accountHpple peekAtSearchWithXPathQuery:@"//p[@class='tit']/a"] texts] componentsJoinedByString:@""];
        NSString *authorMainUrl = [[accountHpple peekAtSearchWithXPathQuery:@"//p[@class='tit']/a"] objectForKey:@"href"];
        NSString *wxID = [[accountHpple peekAtSearchWithXPathQuery:@"//label[@name='em_weixinhao']"] text];
//        NSString *lastMonthArticleNum = ;
        NSArray *dl = [accountHpple searchWithXPathQuery:@"//dl"];
        NSMutableArray *descriptions = [NSMutableArray array];
//        NSString *contentUrl = @"";
        for (TFHppleElement *infoElement in dl) {
            TFHpple *desHpple = [[TFHpple alloc] initWithHTMLData:[infoElement.raw dataUsingEncoding:NSUTF8StringEncoding]];
            TFHppleElement *desElement = [desHpple peekAtSearchWithXPathQuery:@"//dt"];
            NSString *desKey = [desElement lastText];
            if ([desKey isEqualToString:@"最近文章："]) {
                [descriptions addObject:[NSDictionary dictionaryWithObject:[[[desHpple peekAtSearchWithXPathQuery:@"//dd/a"] texts] componentsJoinedByString:@""] forKey:desKey]];
//                contentUrl = [[desHpple peekAtSearchWithXPathQuery:@"//dd/a"] objectForKey:@"href"];
            } else if ([desKey isEqualToString:@"认证："]) {
                [descriptions addObject:[NSDictionary dictionaryWithObject:[[[desHpple peekAtSearchWithXPathQuery:@"//dd"] texts] componentsJoinedByString:@""] forKey:@"微信认证："]];
            } else {
                [descriptions addObject:[NSDictionary dictionaryWithObject:[[[desHpple peekAtSearchWithXPathQuery:@"//dd"] texts] componentsJoinedByString:@""] forKey:desKey]];
            }
        }
        
        WWAccountModel *model = [[WWAccountModel alloc] init];
        model.iconUrl = iconUrl;
        model.author = author;
        model.authorMainUrl = authorMainUrl;
        model.wxID = wxID;
        model.descriptions = [descriptions copy];
//        model.contentUrl = contentUrl;
        
        [accountInfos addObject:model];
    }
    
    self.accountInfos = [accountInfos copy];
    
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
